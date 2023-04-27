function fun_teaching_glm(model, slice)
    %% fun_teaching_glm.m
    % Natalia Velez, last update December 2022
    % Catch-all function to run GLMs
    %
    % model: GLM label (string)
    %  parametric: Main model-based regressors
    %  empirical: Belief regressors estimated from human students' responses
    %  control: Update learner's belief by a constant amount at each time step
    %  blended: A combination of main + control, used to partial out the
    %  effects of time on task
    % 
    % slice: integer between 0-6, used to parallelize first-level modeling
    
    %% (1) Set up environment
    analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
    spm_config_dir = fullfile(spm('Dir'), 'config');
    addpath(analysis_dir);
    addpath(spm_config_dir);
    
    %% (2) Prepare model inputs
    EXPT=fun_glm_inputs('teaching', model, @fun_teaching_multi);
    
    %% (3) Run subject-level modeling
    %subs = (1:4)+slice*4;
    subs = slice; % TEMPORARY CHANGE
    ccnl_fmri_glm_bids(EXPT,'teaching', model, subs,false);
end