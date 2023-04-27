%% script_QA_blended_contrasts.m
% Natalia Velez, last updated December 2022
% Estimate contrasts for parametric regressors after partialling out
% effects of time 

%% (1) Set up environment
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Prepare inputs to contrasts
contrasts = {'+pTrue', '-pTrue', '+KL', '-KL', '+time', '-time'};

expt_file = ['../../BIDS_data/derivatives/model_inputs/' ...
    'task-teaching_model-blended_desc-EXPT.mat'];
load(expt_file, 'EXPT')

%% (2) Estimate contrasts
ccnl_fmri_con_bids(EXPT,'teaching', 'blended', contrasts, 1:28);