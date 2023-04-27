%% script_6_glm_evidences
% Natalia Velez, November 2022
% This script calculates the Bayesian information criterion (BIC) for 
% three GLMs:
% (1) main: Based on the model's prediction of learners' beliefs
% (2) empirical: Based on learners' actual reported beliefs in a separate task
% (3) control: Based on a null model that increases the learner's belief by a
% constant amount based on time elapsed, regardless of the information
% presented

%% Setup
% Set up environment
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/';
lib_dir = fullfile(analysis_dir, 'mfit');
addpath(lib_dir);

% Get ROI names
roi_dir = fullfile(analysis_dir, 'fmri_analysis/roi_library/fmriprep_space/');
q = dir([roi_dir '/*.nii']);

roi_names = cellfun(@(r) strrep(r, '.nii', ''), {q.name}, 'UniformOutput', 0);
valid_rois = cellfun(@isempty,regexp(roi_names,'(l|r)ACC'));
roi_names = roi_names(valid_rois);

% Model names
all_models = {'controlpTrue', 'blended', 'empiricalBlended'};
contrasts = {[1,2], [1,3]};
con_names = {'modelVcontrol', 'empiricalVcontrol'};

%% Model comparison
% Set up directories
bic_dir = 'outputs/glm_bic';
bic_template = fullfile(bic_dir, 'roi-%s_model-%s_desc-BIC.mat');

out_dir = 'outputs/glm_comparison';
out_template = fullfile(out_dir, 'roi-%s_contrast-%s_desc-PXP.json');
status = mkdir(out_dir);

for c = 1:length(contrasts)
    con_name = con_names{c};
    model_names = all_models(contrasts{c});

    for r = 1:length(roi_names)
        roi = roi_names{r};
        
        % Load BICs
        roi_lme = struct('name', model_names, 'evidence', cell(1,length(model_names)));
        for m = 1:length(model_names)
            model = model_names{m};
            bic_file = sprintf(bic_template, roi, model);
            load(bic_file, 'bic');
        
            roi_lme(m).evidence = -0.5*bic;
            clear bic;
        end
        
        c_mtx = [roi_lme(:).evidence];
        [alpha,exp_r,xp,pxp,bor,g] = bms(c_mtx);
        c_struct = struct('roi', roi, 'contrast', con_name, 'models', ...
            {{roi_lme(:).name}}, 'alpha', alpha, 'exp_r', exp_r, 'xp', xp, ...
            'pxp', pxp, 'bor', bor, 'g', g);
    
        out_c = sprintf(out_template, roi, con_name);
        c_txt = jsonencode(c_struct);
    
        fid=fopen(out_c,'w');
        fprintf(fid, c_txt);
        fclose(fid);
    end
end
