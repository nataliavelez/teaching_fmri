%% script_2_tomloc_contrasts.m
% Natalia Velez, November 2021
% Estimate contrasts for ToM localizer

%% (1) Set up environment
analysis_dir = '/ncf/gershman/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Prepare inputs to contrasts
contrasts = {'+belief -photo', '+photo -belief', ...
    '+belief +photo', '-belief -photo'};

expt_file = ['../../BIDS_data/derivatives/model_inputs/' ...
    'task-tomloc_model-localizer_desc-EXPT.mat'];
load(expt_file, 'EXPT')

%% (2) Estimate contrasts
ccnl_fmri_con_bids(EXPT,'tomloc', 'localizer',contrasts,1:28);