%% script_6_separate_contrasts.m
% Natalia Velez, April 2022
% Estimate contrasts for teaching task from separate GLMs

%% (1) Set up environment
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Prepare inputs to contrasts
param_reg = {'pTrue', 'KL'};
for reg=param_reg
    contrasts = {['+' reg{1}] ['-' reg{1}]};

    expt_file = ['../../BIDS_data/derivatives/model_inputs/' ...
        'task-teaching_model-parametric' reg{1} '_desc-EXPT.mat'];
    load(expt_file, 'EXPT');

    ccnl_fmri_con_bids(EXPT,'teaching', ['parametric' reg{1}], contrasts, 1:28);
end