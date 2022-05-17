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

    model_names = {'nonparametric', 'parametricKL', 'parametricpTrue'};
    for m = 1:length(model_names)
         % (2) Prepare model inputs
        model = model_names{m};
        EXPT=fun_glm_inputs('teaching', model, @fun_teaching_multi);
        
        % (3) Run subject-level modeling
        subs = (1:4)+slice*4;
        ccnl_fmri_glm_bids(EXPT,'teaching', model,subs,false);
    end
    
end