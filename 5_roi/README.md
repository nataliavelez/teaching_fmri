# Region of interest analyses

Contents:

* `0_register_roi.ipynb`: Register anatomical ACCg ROI and hypothesis spaces for mentalizing ROIs to the same space as our functional images
* `1_roi_picker.sh`: Pick mentalizing ROIs based on localizer results
* `2_check_roi.ipynb`: Check resulting functional ROIs 
* `3_roi_univariate.ipynb`: Extract ROI-based univariate results
* `4_wholebrain_univariate.ipynb`: Plot whole-brain results at different statistical threholds
* `5_glm_bic.sbatch`: Calculates BICs for a control model that merely tracks the number of examples presented (Time; GLM 5), and GLMs that additionally track learners' beliefs (Time + Belief; GLM 6)
* `6_glm_evidences.sbatch`: Calculates protected exceedance probabilities for GLMs 5 & 6 in each ROI
* `7_glm_comparison`: Plot GLM model comparison results