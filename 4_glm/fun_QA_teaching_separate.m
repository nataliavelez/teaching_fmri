function fun_QA_teaching_separate(slice)
    %% fun_QA_teaching_separate
    % Natalia Velez, April 2022
    % QA: Estimate each parametric regressor in a separate GLM
    % slice: integer between 0-6, used to parallelize first-level modeling
    
    % (1) Set up environment
    analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
    spm_config_dir = fullfile(spm('Dir'), 'config');
    addpath(analysis_dir);
    addpath(spm_config_dir);

    param_reg = {'KL', 'pTrue'};
    for reg=param_reg
         % (2) Prepare model inputs
        model = ['parametric' reg{1}];
        EXPT=fun_glm_inputs('teaching', model, @fun_teaching_multi);
        
        % (3) Run subject-level modeling
        subs = (1:4)+slice*4;
        ccnl_fmri_glm_bids(EXPT,'teaching', model,subs,false);
    end
    
end