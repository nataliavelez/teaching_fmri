#!/usr/bin/env python
# coding: utf-8

# # Copy over inputs for first-level modeling
# Natalia Vélez, November 2021

# Setup:
import os, gzip, sys
import numpy as np
from os.path import join as opj
from shutil import copyfile

# Project-specific modules
sys.path.append('..')
from utils import gsearch

# Project directories
project_dir = '../../BIDS_data/derivatives/'
fmriprep_dir = opj(project_dir, 'fmriprep')
out_dir = opj(project_dir, 'model_inputs')

# If the output directory doesn't exist, make it!
if not os.path.isdir(out_dir):
    print('Creating new path: %s' % out_dir)
    os.makedirs(out_dir, exist_ok=True)
else:
    print('Saving outputs to existing directory: %s' % out_dir)


# Helper function: Unpack .gz files
def gunzip(source_filepath, dest_filepath, block_size=65536):
    with gzip.open(source_filepath, 'rb') as s_file,             open(dest_filepath, 'wb') as d_file:
        while True:
            block = s_file.read(block_size)
            if not block:
                break
            else:
                d_file.write(block)


# Load participants:
excluded_subs = np.loadtxt('../1_preprocessing/outputs/excluded_participants.txt', dtype=str)
all_subs = np.array(['sub-%02d' % i for i in range(1,31)])
subs = np.setdiff1d(all_subs, excluded_subs)

print('Copying over data from %i participants' % len(subs))
print(subs)

# Main loop: Iterate over participants
for s in subs:

    print('\n==== %s ====' % s)
    # Create output directories
    print('Saving files to: %s\n' % opj(out_dir, s))
    os.makedirs(opj(out_dir, s, 'anat'), exist_ok=True)
#     os.makedirs(opj(out_dir, s, 'func'), exist_ok=True)

    # Find input files
    struct_file = gsearch(fmriprep_dir, s, 'anat', '*space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz')
    struct_file = struct_file[0]
    print('Structural: %s' % struct_file)

    mask_file = gsearch(fmriprep_dir, s, 'anat', '*space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz')
    mask_file = mask_file[0]
    print('Mask: %s' % mask_file)

#     func_files = gsearch(smooth_dir, s, 'func', '*smoothed*.nii')
#     print('%i functional files found' % len(func_files))
#     print(*func_files, sep='\n')

    # Unzip anatomical files
    print('\nCopying structurals...')
    struct_out = struct_file.replace('fmriprep', 'model_inputs').replace('.nii.gz', '.nii')
    gunzip(struct_file, struct_out)
    print('Structural saved to: %s' % struct_out)

    mask_out = mask_file.replace('fmriprep', 'model_inputs').replace('.nii.gz', '.nii')
    gunzip(mask_file, mask_out)
    print('Mask saved to: %s' % mask_out)

#     # Copy functionals
#     print('\nCopying functionals...')
#     func_out = [f.replace('smooth_fmriprep', 'modelspec') for f in func_files]
#     for f_in, f_out in zip(func_files, func_out):
#         copyfile(f_in, f_out)
#         print(f_out)
        

