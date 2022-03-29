%% script_5_teaching_main.m
% Natalia Velez, March 2022
% Main model for teaching task

%% (1) Set up environment
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Prepare model inputs
EXPT=fun_glm_inputs('teaching', 'parametric', @fun_teaching_multi);

%% (3) Run subject-level modeling
ccnl_fmri_glm_bids(EXPT,'teaching','parametric',1:28,false);