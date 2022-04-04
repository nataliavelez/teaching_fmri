function fun_5_teaching_main(slice)
    %% fun_5_teaching_main.m
    % Natalia Velez, March 2022
    % Main model for teaching task
    % slice: integer between 0-6, used to parallelize first-level modeling
    
    %% (1) Set up environment
    analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
    spm_config_dir = fullfile(spm('Dir'), 'config');
    addpath(analysis_dir);
    addpath(spm_config_dir);
    
    %% (2) Prepare model inputs
    EXPT=fun_glm_inputs('teaching', 'parametric', @fun_teaching_multi);
    
    %% (3) Run subject-level modeling
    subs = (1:4)+slice*4;
    ccnl_fmri_glm_bids(EXPT,'teaching','parametric',subs,false);
end