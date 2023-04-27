%% script_5_glm_bic
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
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis';
lib_dir = fullfile(analysis_dir, 'ccnl-fmri');
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(lib_dir);
addpath(spm_config_dir);

% Find ROI files
roi_dir = fullfile(analysis_dir, 'roi_library','fmriprep_space');
q = dir([roi_dir '/*.nii']);
roi_files = cellfun(@(x,y) fullfile(x,y), {q.folder}, {q.name}, ...
    'UniformOutput', false);
valid_rois = cellfun(@isempty,regexp(roi_files,'(l|r)ACC'));
roi_files = roi_files(valid_rois);

% Find model files
%model_names = {'controlpTrue', 'blended', 'blendedEmpirical'};
model_names = {'empiricalBlended'};
model_dir = fullfile('..', '..', 'BIDS_data', 'derivatives', 'model_inputs');
model_template = fullfile(model_dir, 'task-teaching_model-%s_desc-EXPT.mat');

%% Main loop: Iterating over ROI types (functional, Neurosynth) and GLMs
% Create output directory
out_dir = fullfile('outputs', 'glm_bic');
status = mkdir(out_dir);

for m = 1:length(model_names)
    model = model_names{m}; % iterate over models
    expt_path = sprintf(model_template, model);
    load(expt_path, 'EXPT');
    fprintf('==== Model: %s ====\n', model);

    for r = 1:length(roi_files)
        roi_f = roi_files{r}; % iterate over ROIs
        disp(roi_f)
        masks = repmat({roi_f}, 1, length(EXPT.subject));
        bic = ccnl_bic_bids(EXPT, model, masks);

        % save output to file
        [fp, roi_name, ext] = fileparts(roi_f);
        out_file = sprintf('roi-%s_model-%s_desc-BIC.mat', ...
            roi_name, model);

        save(fullfile(out_dir, out_file), 'bic');
    end
end