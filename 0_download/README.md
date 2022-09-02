# Download & format raw data

In this directory: 

* `session_labels.txt`: Labels of sessions to pull from CBSCentral
* `0_bids_config.ipynb`: Configure the files for conversion to BIDS (e.g., specifying which functional runs belong which task, and which fieldmaps correspond to which functional runs)
* `1_download_session.sh`: Download fMRI sessions from CBSCentral
* `2_run_dcm2niix.sh`: Convert raw dicom images to NIFTI
* `3_deface_anats.sh`: Remove faces from anatomical images
* `4_bids.sh`: Rename/move files to comply with [BIDS](http://bids.neuroimaging.io/)
* `5_check_bids_compatibility.sh`: Check that the resulting dataset is BIDS-compatible
* `6_check_completeness`: Check that everything that needed to be downloaded is in its place
