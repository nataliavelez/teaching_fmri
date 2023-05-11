%% script_3_tomloc_model.m
% Natalia Velez, November 2021
% Run subject-level modeling for ToM localizer

%% (1) Set up environment
analysis_dir = '/ncf/gershman/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Prepare model inputs
EXPT=fun_glm_inputs('tomloc', 'localizer', @fun_tomloc_multi);

%% (3) Run subject-level modeling
ccnl_fmri_glm_bids(EXPT,'tomloc','localizer',1:28,false);