function fun_1_student_main(slice)
    %% fun_1_student_main.m
    % Natalia Velez, April 2022
    % Estimate GLM for teaching task using empirical GLM
    % slice: integer between 0-6, used to parallelize first-level modeling
    
    %% (1) Set up environment
    analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
    glm_dir = '../3_glm';
    spm_config_dir = fullfile(spm('Dir'), 'config');
    addpath(analysis_dir);
    addpath(spm_config_dir);
    addpath(glm_dir);
    
    %% (2) Prepare model inputs
    EXPT=fun_glm_inputs('teaching', 'student', @fun_student_multi);
    
    %% (3) Run subject-level modeling
    subs = (1:4)+slice*4;
    ccnl_fmri_glm_bids(EXPT,'teaching','student',subs,false);
end