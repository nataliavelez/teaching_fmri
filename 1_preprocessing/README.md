# fMRI preprocessing

Contents:
* `1_mriqc_participant.sh`: Run MRIQC on all participants
* `2_mriqc_group.sbatch`: Generate group-level image quality metrics
* `3_fmriprep.sh`: Run FMRIPREP on all participants
* `4_exclude_wiggly_participants.ipynb`: Load motion regressors and exclude participants for excessive motion
* `5_smooth.sh`: Smooth functional images using SPM12 (calls on `smooth_fmriprep_outputs.m`)
* `6_copy_inputs.sbatch`: Copy over preprocessed images for use in subject-level modeling
* `7_copy_confounds.sbatch`: Copy over nuisance regressors for use in subject-level modeling