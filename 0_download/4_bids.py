#!/usr/bin/env python
# coding: utf-8

# # Move NIFTI files to BIDS-formatted dataset
# Natalia Vélez, September 2021

import re,os,sys,yaml,json,pprint,glob
from os.path import join as opj
from shutil import copyfile

def str_extract(pattern, s): return re.search(pattern,s).group(0)
def gsearch(*args): return glob.glob(opj(*args))


# Read participant data
_,ses = sys.argv
sub_id = 'sub-%s' % str_extract('[0-9]+$', ses)

# Important directories
in_dir = '/ncf/gershman/User/nvelezalicea/teaching/raw_data/%s/nifti' % ses
out_dir = '/ncf/gershman/User/nvelezalicea/teaching/BIDS_data/%s' % sub_id
protocol_file = 'outputs/config/%s.yaml' % ses

# Read protocol
with open(protocol_file, 'r') as f:
    protocol = yaml.load(f)

print('=== %s ===' % sub_id)
print('Reading NIFTI files from: %s' % in_dir)
print('Saving files to: %s\n' % out_dir)
os.makedirs(out_dir, exist_ok = True)
pprint.pprint(protocol)


# ## Anatomical
print('=== Anatomical image ===')
anat_seq = protocol['anat']['T1w']['scan']
anat_file = gsearch(in_dir, 'RAW_T1_MEMPRAGE*_%i_defaced.nii' % anat_seq)
anat_file = anat_file[0]
print('Found anatomical: %s' % anat_file)

anat_meta_file = anat_file.replace('_defaced.nii', '.json')
print('Found metadata: %s' % anat_meta_file)

with open(anat_meta_file, 'r') as f:
    anat_meta = json.load(f)
del anat_meta['ImageComments']
del anat_meta['ProcedureStepDescription']

pprint.pprint(anat_meta)

# Make directory for anatomical file
anat_dir = opj(out_dir, 'anat')
anat_out = opj(anat_dir, '%s_T1w.nii') % sub_id
os.makedirs(anat_dir, exist_ok=True)

# Copy anatomical
print('Copying anatomical to: %s' % anat_out)
copyfile(anat_file, anat_out)

# Copy metadata
anat_meta_out = anat_out.replace('.nii', '.json')
print('Copying metadata to: %s' % anat_meta_out)
with open(anat_meta_out, 'w') as f:
    json.dump(anat_meta, f)


# ## Functional images
print('=== Functional images ===')
func_seqs = protocol['func']['bold']
func_dir = opj(out_dir, 'func')
os.makedirs(func_dir, exist_ok=True)

for seq in func_seqs:
    # Input file
    func_file = gsearch(in_dir, '*Minn_HCP*_%i.nii' % seq['scan'])
    func_file = func_file[0]
    print('Found functional: %s' % func_file)
    
    # Metadata
    func_meta_file = func_file.replace('.nii', '.json')
    print('Found metadata: %s' % func_meta_file)

    with open(func_meta_file, 'r') as f:
        func_meta = json.load(f)
    del func_meta['ImageComments']
    del func_meta['ProcedureStepDescription']
    func_meta['TaskName'] = seq['task']

    # Single-band reference
    sbref_file = gsearch(in_dir, '*Minn_HCP*_%i.nii' % (seq['scan']-1))
    sbref_file = sbref_file[0]
    print('Found single-band reference: %s' % sbref_file)
    
    sbref_meta_file = sbref_file.replace('.nii', '.json')
    with open(sbref_meta_file, 'r') as f:
        sbref_meta = json.load(f)
    del sbref_meta['ImageComments']
    del sbref_meta['ProcedureStepDescription']
    sbref_meta['TaskName'] = seq['task'] 
    
    # Outputs
    func_out = opj(func_dir, '%s_task-%s_run-%02d_bold.nii') % (sub_id, seq['task'], seq['run'])
    print('Copying functional to: %s' % func_out)
    copyfile(func_file, func_out)
    
    func_meta_out = func_out.replace('.nii', '.json')
    print('Copying metadata to: %s' % func_meta_out)
    with open(func_meta_out, 'w') as f:
        json.dump(func_meta, f)
        
    sbref_out = func_out.replace('_bold.nii', '_sbref.nii')
    print('Copying single-band reference to: %s' % sbref_out)
    copyfile(sbref_file, sbref_out)
    
    sbref_meta_out = sbref_out.replace('.nii', '.json')
    print('Copying reference metadata to: %s' % sbref_meta_out)
    with open(sbref_meta_out, 'w') as f:
        json.dump(sbref_meta, f)
    
    print('')

# ## Fieldmaps
if 'fmap' in protocol:
    print('=== Fieldmaps ===')

    fmap_seqs = protocol['fmap']['epi']
    fmap_dir = opj(out_dir, 'fmap')
    os.makedirs(fmap_dir, exist_ok=True)

    for seq in fmap_seqs:
        fmap_file = gsearch(in_dir, '*SEFieldMap*_%i.nii' % seq['scan'])
        fmap_file = fmap_file[0]
        print('Found fieldmap: %s' % fmap_file)

        # Metadata
        fmap_meta_file = fmap_file.replace('.nii', '.json')
        print('Found metadata: %s' % fmap_meta_file)

        with open(fmap_meta_file, 'r') as f:
            fmap_meta = json.load(f)
        del fmap_meta['ImageComments']
        del fmap_meta['ProcedureStepDescription']
        fmap_meta['IntendedFor'] = ['func/%s_%s_bold.nii' % (sub_id, epi) for epi in seq['intended_for']]

        #pprint.pprint(fmap_meta)

        # Outputs
        fmap_out = opj(fmap_dir, '%s_dir-%s_run-%02d_epi.nii') % (sub_id, seq['direction'], seq['run'])
        print('Copying fieldmap to: %s' % fmap_out)
        copyfile(fmap_file, fmap_out)

        fmap_meta_out = fmap_out.replace('.nii', '.json')
        print('Copying metadata to: %s' % fmap_meta_out)
        with open(fmap_meta_out, 'w') as f:
            json.dump(fmap_meta, f)

        print('')

