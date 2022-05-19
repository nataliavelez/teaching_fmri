function fun_exploratory_teaching_identifiability(slice)
    %% fun_exploratory_teaching_identifiability
    % Natalia Velez, May 2022
    % Exploratory analysis: Split contrasts according to whether the true
    % hypothesis is uniquely identifiable
    % slice: integer between 0-6, used to parallelize first-level modeling
    
    % (1) Set up environment
    analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
    spm_config_dir = fullfile(spm('Dir'), 'config');
    addpath(analysis_dir);
    addpath(spm_config_dir);

     % (2) Prepare model inputs
    EXPT=fun_glm_inputs('teaching', 'identifiability', @fun_teaching_multi);
    
    % (3) Run subject-level modeling
    subs = (1:4)+slice*4;
    ccnl_fmri_glm_bids(EXPT,'teaching', 'identifiability',subs,false);
end