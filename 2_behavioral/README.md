# Behavioral analysis & model comparison

Main pipeline:

* `teaching_models.py`: Project-specific model. Contains methods to simulate, fit, and compare different behavioral models.
* `0_behavioral_wrangling.ipynb`: Runs a few basic quality checks (e.g., to ensure that each participant has the correct number of behavioral files), and saves a dataframe of trial-by-trial examples and ratings (`outputs/teaching_behavior.csv`) and a dataframe of teacher performance (`outputs/teaching_compliance.csv`).
* `1_behavioral_plots.ipynb`: Creates two classes of plots: Hints selected by individuals, and their trial by trial predictions (`plots/examples_ind`), and average examples and predictions across all teachers (`plots/examples_agg`)
* `2_fit_models.sh`: Main script for model fitting. Creates model fitting jobs through `2_fit_model.sbatch`, which in turn calls `2_fit_models.py` or `2_fit_strong_model.py` (a mulligan for the strong-sampling models).
* (TODO) `3_model_comparison.sbatch`: 
* `4_tomloc_events.ipynb`: Creates event files for Theory of Mind localizer 
* (TODO) `5_teaching_events.ipynb`: Creates GLMs for teaching task
* (TODO) `6_teaching_rdms.ipynb`: Creates RDMs derived from teaching task, for use in multivariate analyses

In addition, this folder contains scripts to test for model identifiability: 

* `QA1_simulate_data.sbatch`: Generates simulated data from the utility-maximizing model by systematically varying weights and alpha.
* `QA2_parameter_recovery.sbatch`: Runs model fitting on simulated data.
* `QA3_simulation_results`: Checks the results of QA1--2