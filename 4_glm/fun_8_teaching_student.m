function fun_8_teaching_student(slice)
    %% fun_8_teaching_student.m
    % Natalia Velez, last updated August 2022
    % Empirically-derived regressors from student task
    % slice: integer between 0-6, used to parallelize first-level modeling
    
    %% (1) Set up environment
    analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
    spm_config_dir = fullfile(spm('Dir'), 'config');
    addpath(analysis_dir);
    addpath(spm_config_dir);
    
    %% (2) Prepare model inputs
    EXPT=fun_glm_inputs('teaching', 'empirical', @fun_teaching_multi);
    
    %% (3) Run subject-level modeling
    subs = (1:4)+slice*4;
    ccnl_fmri_glm_bids(EXPT,'teaching','empirical', subs,false);
end