#!/usr/bin/env python
# coding: utf-8

# # Pick functionally defined ROIs

# In[1]:
# # Use non-interactive backend
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Import libraries
import os
import sys
from glob import glob
from os.path import join as opj
import numpy as np
import pandas as pd
import nilearn
import nibabel as nb
from scipy import stats
import nilearn.input_data
import nilearn.plotting
import nilearn.regions
import nilearn.masking
from scipy import ndimage

from nipype.interfaces import fsl

# Parse inputs
_, sub_no = sys.argv
sub_no = int(sub_no)
subject = 'sub-%02d' % sub_no
print('===== %s =====' % subject)
rois = ['DMPFC', 'LTPJ', 'MMPFC', 'PC', 'RSTS', 'RTPJ', 'VMPFC']

# Project directories:
hypothesis_dir = '/ncf/gershman/User/nvelezalicea/fmri_analysis/roi_library/fmriprep_space'
project_dir = '/ncf/gershman/Lab/natalia_teaching/BIDS_data/derivatives/'
roi_dir = opj(project_dir, 'roi_picker')
out_dir = opj(roi_dir, subject, 'func')

print('Reading hypothesis spaces from: %s' % roi_dir)
print('Saving outputs to: %s' % out_dir)

if not os.path.isdir(out_dir):
    os.makedirs(out_dir)

# Load Belief > Photo tstat image:
tstat_dir = opj(project_dir, 'glm', subject, 'func', 'task-tomloc_model-localizer')
tstat_file = opj(tstat_dir, 'spmT_0001.nii')
tstat_img = nilearn.image.load_img(tstat_file)
tstat_data = tstat_img.get_fdata()

# In[5]:
df = 246.0 # hardcoded, but this is from SPM.xX.erdf
thresholds = stats.t.ppf([0.999, 0.99, 0.95], df)

# Cluster threshold:
n_voxels = 10 # Minimum extent (in voxels)
voxel_dims = tstat_img.header.get_zooms() # Voxel dimensions (mm)
voxel_volume = np.prod(voxel_dims) # Volume of a single voxel (mm^3)
min_volume = np.ceil(n_voxels*voxel_volume)
print('Minimum cluster volume: %.01f' % min_volume)

# Define ToM ROIs:
for roi in rois:
    print('Finding %s...' % roi)
    # ROI file
    roi_out = opj(out_dir, '%s_task-tomloc_model-localizer_desc-%s_mask.nii.gz') % (subject, roi)
    fig_out = roi_out.replace('.nii.gz', '.png')

    # Load hypothesis space
    hypothesis_file = opj(hypothesis_dir, roi+'.nii.gz')
    hypothesis = nilearn.image.load_img(hypothesis_file)

    # Mask z-stat image using ROI hypothesis space
    hypothesis_data = hypothesis.get_fdata()
    masked_tstat_data = np.multiply(tstat_data, hypothesis_data)

    # Iterate over thresholds (p < 0.001, p < 0.01, p < 0.05)
    for thresh in thresholds:
        print('Trying threshold t > %0.2f' % thresh)
        above_thresh = masked_tstat_data > thresh
        thresh_data = np.multiply(masked_tstat_data, above_thresh)
        thresh_tstat = nb.Nifti1Image(thresh_data, tstat_img.affine, tstat_img.header)

        if np.any(thresh_tstat.get_data() > 0):
            # Try to define cluster:
            try:
                clusters_img = nilearn.regions.connected_regions(thresh_tstat, min_region_size=min_volume)
                clusters_data = clusters_img[0].get_data()
                clusters_bin = clusters_data > 0

                # Find peak voxel
                peak_voxel_idx = np.argmax(clusters_data, axis=None)
                peak_voxel_coords = np.unravel_index(peak_voxel_idx, np.shape(clusters_data))
                peak_voxel_cluster = peak_voxel_coords[-1]
                
                # Final roi
                ind_roi = clusters_bin[:,:,:,peak_voxel_cluster]
                ind_roi_img = nb.Nifti1Image(ind_roi, tstat_img.affine, tstat_img.header)
                ind_roi_plot = nilearn.plotting.plot_roi(ind_roi_img, title='%s: %s ROI(t > %f)' % (subject, roi, thresh))
                            
                # Save to file
                ind_roi_plot.savefig(fig_out)
                nb.save(ind_roi_img, roi_out)

                break
            # Continue iterating if clusters are too small
            except TypeError:
                print('No k > 10 clusters found in %s at t > %0.2f, relaxing threshold' % (roi, thresh))
                continue
        elif thresh < 2:
            print('No %s found for %s!' % (roi, subject))
        else:
            print('No suprathreshold voxels found in %s at t > %0.2f, relaxing threshold' % (roi, thresh))

