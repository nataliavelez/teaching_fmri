%% script_2_strudent_contrasts.m
% Natalia Velez, March 2022
% Estimate contrasts for parametric regressors empirically derived from 
% student data

%% (1) Set up environment
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Prepare inputs to contrasts
contrasts = {'+pTrue', '+KL'};

expt_file = ['../../BIDS_data/derivatives/model_inputs/' ...
    'task-teaching_model-student_desc-EXPT.mat'];
load(expt_file, 'EXPT')

%% (2) Estimate contrasts
ccnl_fmri_con_bids(EXPT,'teaching', 'student', contrasts, 1:28);