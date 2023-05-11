# Estimating general linear model
Natalia Vélez, March 2022

The code in this folder uses a fork of the following package for GLM estimation:
https://github.com/sjgershm/ccnl-fmri

And the following package for Bayesian random effects analysis:
https://github.com/sjgershm/mfit

Contents:

_Processing steps_
* `1_tomloc_events.ipynb`: Prepare events for Theory Of Mind localizer task
* `2_teaching_events`: Prepare events for teaching task
* `3_tomloc_model.sbatch`: Estimate GLM for functional localizer task
* `4_tomloc_contrasts.sbatch`: Estimate Belief > Photo contrast for localizer task 
* `5_teaching_main.sh`: Estimate model using model-based parametric regressors (GLM 1)
* `6_teaching_contrasts.sbatch`: Estimate contrasts for GLM 1
* `7_teaching_student.sh`: Estimate model using parametric regressors derived from human learners' average responses (GLM 2)
* `8_student_contrasts.sh`: Estimate contrasts for GLM 2

_Quality checks_
* `QA_1_teaching_separate.sh`: Estimate parametric regressors from GLM1 in two separate GLMs (GLM 3-4)
* `QA_2_separate_contrasts.sbatch`: Estimate contrasts for GLM 3-4
* `QA_3_glm_correlations.ipynb`: Check correlations between parametric regressors
* `QA_4_teaching_control`: Estimate control (Time) GLM (GLM 5)
* `QA_5_control_contrasts`: Estimate contrasts for GLM 5
* `QA_6_teaching_blended`: Estimate Time + Belief GLM (GLM 6)
* `QA_7_blended_contrasts`: Estimate contrasts for GLM 6

_Key helper functions_
* `fun_teaching_multi`, `fun_tomloc_multi`: Prepares inputs to estimate GLMs based on responses to the teaching and localizer tasks, respectively 
* `fun_glm_inputs`: Prepare data structure for GLM estimation
* `fun_teaching_glm`: Catch-all function to estimate GLMs for the teaching task