# Behavioral analysis & model comparison

Contents:

_Processing steps_
* `0_behavioral_wrangling.ipynb`: Runs a few basic quality checks (e.g., to ensure that each participant has the correct number of behavioral files), and saves a dataframe of trial-by-trial examples and ratings (`outputs/teaching_behavior.csv`) and a dataframe of teacher performance (`outputs/teaching_compliance.csv`).
* `1_behavioral_plots.ipynb`: Creates two classes of plots: Hints selected by individuals, and their trial by trial predictions (`plots/examples_ind`), and average examples and predictions across all teachers (`plots/examples_agg`)
* `2_fit_models.sh`: Main script for model fitting. Creates model fitting jobs through `2_fit_model.sbatch`, which in turn calls `2_fit_models.py` or `2_fit_strong_model.py` (a kludge to fit a random baseline model where all weights = 0).
* `3_simulate_data.sh`: Create simulated datasets using the best-fitting parameters of each model.
* `4_model_recovery.sh`: Compute model evidences for simulated datasets
* `5_process_model_fitting.ipynb`: Reformat model evidences for model comparison using [mfit](https://github.com/sjgershm/mfit)
* `6_pxp.sbatch`: Compute protected exceedance probabilities [(Rigoux et al., 2014)](https://pubmed.ncbi.nlm.nih.gov/24018303/)
* `7_model_comparison`: Plot model comparison results - used to make many of the model results figures.
* `8_model_regressors`: Prepare model-based and control (time-based) regressors for fMRI analysis
* `9_qualitative_checks`: Check qualitative predictions of the model - used to make some supplementary figures.

_Helper files_
* `teaching_models.py`: Contains main methods to simulate, fit, and compare different teaching models.
