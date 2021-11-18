# Neurocomputational mechanisms of teaching
Natalia Vélez, October 2021--

**Table of contents**
These scripts are numbered in the order you would need to execute them to fully reproduce the results of this project.

* `0_download/`: Download raw data from CBSNCentral and re-package it into BIDS format
* `1_preprocessing/`: Preprocessing using fmriprep, and a few additional steps to prepare for modeling with SPM (e.g., smoothing, unzipping .nii.gz files)
* `2_behavioral/`: Behavioral analyses and model predictions
* `3_glm`: Define and estimate GLMs
* `4_roi`: Define regions of interest
* `utils.py`: A project-specific module containing commonly-used functions

**How to use this repository**
