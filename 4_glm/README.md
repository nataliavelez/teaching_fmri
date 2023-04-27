# Estimating general linear model
Natalia Vélez, March 2022

The code in this folder uses a fork of the following package for GLM estimation:
https://github.com/sjgershm/ccnl-fmri

Contents:

* `1_tomloc_events.ipynb`: Prepare events for localizer task
* `2_teaching_events`: Prepare events for teaching task
* `3_tomloc_model.sbatch`: Estimate model for functional localizer task
* `4_tomloc_contrasts.sbatch`: Estimate localizer contrasts
* `5_teaching_main.sh`: Estimate model using model-based parametric regressors (GLM 1)
* `6_teaching_contrasts.sbatch`: Estimate contrasts for model-based regressors
* `7_teaching_student.sh`: Estimate model using parametric regressors derived from human learners' average responses (GLM 2)
* `8_student_contrasts.sh`: Estimate contrasts for empirically-derived regressors
* `QA_1_teaching_separate.sh`: Estimate parametric regressors from GLM1 in two separate GLMs (GLM 3-4)
* `QA_2_separate_contrasts.sbatch`: Estimate contrasts for GLM 3-4
* `QA_3_glm_correlations.ipynb`: Check correlations between parametric regressors