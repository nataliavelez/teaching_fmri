%% script_6_tomloc_contrasts.m
% Natalia Velez, March 2022
% Estimate contrasts for teaching task

%% (1) Set up environment
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Prepare inputs to contrasts
% contrasts = {'+show_identifiablexpTrue -show_unidentifiablexpTrue', ...
%     '-show_identifiablexpTrue +show_unidentifiablexpTrue', ...
%     '+show_identifiablexKL -show_unidentifiablexKL', ...
%     '-show_identifiablexKL +show_unidentifiablexKL'};
contrasts = {'-show_identifiable +show_unidentifiable'};

expt_file = ['../../BIDS_data/derivatives/model_inputs/' ...
    'task-teaching_model-identifiability_desc-EXPT.mat'];
load(expt_file, 'EXPT')

%% (2) Estimate contrasts
ccnl_fmri_con_bids(EXPT,'teaching', 'identifiability', contrasts', 2);