# Neurocomputational mechanisms of teaching
Natalia Vélez, October 2021--September 2022

**Table of contents**
These scripts are numbered in the order you would need to execute them to fully reproduce the results of this project.

* `utils.py`: A project-specific module containing commonly-used functions
* `0_download/`: Download raw data from CBSNCentral and re-package it into BIDS format
* `1_preprocessing/`: Preprocessing using fmriprep, and a few additional steps to prepare for modeling with SPM (e.g., smoothing, unzipping .nii.gz files)
* `2_behavioral/`: Analyze teacher behavior in the scanner task and compare model predictions
* `3_student`: Analyze the behavior of an independent sample of "students" who were tested on teachers' hints on mTurk
* `4_glm`: Define and estimate GLMs
* `5_roi`: Define regions of interest and run fMRI analyses

This repository contains the code used to analyze this project from start to finish, from downloading MRI data to generating figures for publication. Directories and files are numbered in the order they should be run. For example, every script in `0_download` should be run before the scripts in `1_preprocessing` and, within that folder, `0_bids_config` should be run before `1_download_sessions`. Running these scripts out of order may raise errors, as later-numbered scripts rely on intermediate outputs from earlier ones.

A computationally reproducible version of these analyses is in the works—please check back soon!
