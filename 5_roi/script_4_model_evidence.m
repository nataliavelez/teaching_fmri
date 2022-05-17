%% script_4_model_evidence
% Natalia Velez May 2022
% Compute model evidences for GLMs

%% (1) Set up environment
analysis_dir = '/n/gershman_ncf/User/nvelezalicea/fmri_analysis/ccnl-fmri/';
spm_config_dir = fullfile(spm('Dir'), 'config');
addpath(analysis_dir);
addpath(spm_config_dir);

%% (2) Valid participants
subjects = readtable('../1_preprocessing/outputs/valid_participants.txt');
subjects = table2array(subjects); 

%% (3) Find ROI files
roi_labels = {'ACC', 'DMPFC', 'MMPFC', 'PC', 'RSTS', 'RTPJ', 'VMPFC'};
data_dir = '/n/gershman_ncf/Lab/natalia_teaching/BIDS_data/derivatives';
roi_dir = fullfile(data_dir, 'roi_picker');

% fill out cell containing paths to ROI files
roi_paths = cell(length(subjects), length(roi_labels)); 
roi_template = fullfile(roi_dir, 'sub-%02d', 'func', ...
    'sub-%02d_task-tomloc_model-localizer_desc-%s_mask.nii.gz');

for r = 1:length(roi_labels)
    roi = roi_labels{r};
    roi_arr = arrayfun(@(s) sprintf(roi_template, s, s, roi), subjects, ...
        'UniformOutput', false);
    real_roi =  logical(cellfun(@(r) exist(r, 'file'), roi_arr));
    roi_paths(real_roi, r) = roi_arr(real_roi);
end

%% (4) Compute model evidences
model_labels = {'parametric', 'parametricKL', ...
    'parametricpTrue'};
model_struct = struct('model_name', cell(size(model_labels)), ...
    'bic', cell(size(model_labels)));
model_evidences = struct('roi_name', cell(size(roi_labels)), 'models', ...
    cell(size(roi_labels)));

for r = 1:length(roi_labels)

    % initialize struct
    roi = roi_labels{r};
    model_evidences(r).roi_name = roi;
    model_evidences(r).models = model_struct;
    
    for m = 1:length(model_labels)
        % label model
        model = model_labels{m};
        model_evidences(r).models(m).model_name = model;
        
        % get model expt structure
        model_file = fullfile(data_dir, 'model_inputs', ...
            ['task-teaching_model-' model '_desc-EXPT.mat']);
        load(model_file, 'EXPT');
        
        % compute model evidences
        bic = ccnl_bic_bids(EXPT, model, roi_paths(:,r), subjects);
        model_evidences(r).models(m).bic = bic;
    end

end

% save to file
save('outputs/glm_model_evidences.mat', 'model_evidences')