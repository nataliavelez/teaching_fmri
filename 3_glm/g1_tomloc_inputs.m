% 1_TOMLOC_INPUTS
% Creates EXPT structure for modeling tomloc task
% Reference: github.com/sjgershm/ccnl-fmri/wiki/Creating-the-EXPT-structure
% Natalia Velez, November 2021

%% Experiment directories
data_dir = '/ncf/gershman/Lab/natalia_teaching/BIDS_data/derivatives';
model_dir = fullfile(data_dir, 'model_inputs');

%% Experiment info
EXPT.TR = 2;                        % repetition time (seconds)
EXPT.create_multi = @tomloc_multi;  % handle for function that creates multi structures
EXPT.modeldir = model_dir; % where to put model results

%% Select sample for analysis
all_subs = 1:30;

% read subject IDs
f = fopen('../1_preprocessing/outputs/excluded_participants.txt');
excluded_ids = textscan(f, '%s\n');
fclose(f);
excluded_ids = excluded_ids{1};

% convert subject ID -> numeric
excluded_subs = extract(excluded_ids, digitsPattern);
excluded_subs = cellfun(@str2num, excluded_subs);

% final subjects, minus exclusions
subs = setdiff(all_subs, excluded_subs);

%% Subject info
EXPT.subject = struct('modeldir', {}, 'functional', {}, ...
    'structural', {}, 'mask', {});
for s = 1:length(subs)
    sub = subs(s);
    % (1) Output directory
    sub_id = sprintf('sub-%02d', sub);
    sub_dir = fullfile(model_dir, sub_id);
    EXPT.subject(s).modeldir = sub_dir;

    % (2) Structural & mask files
    struct_query = dir(fullfile(sub_dir, 'anat', ...
        '*T1w.nii'));
    EXPT.subject(s).structural = fullfile('anat', struct_query(1).name);

    mask_query = dir(fullfile(sub_dir, 'anat', ...
        '*brain_mask.nii'));
    EXPT.subject(s).mask = fullfile('anat', mask_query(1).name);

    % (3) functional files
    func_query = dir(fullfile(sub_dir, 'func', ...
        '*task-tomloc*desc-smoothed*.nii'));
    sub_funcs = cellfun(@(f) fullfile('func', f), {func_query.name}, ...
        'UniformOutput', 0);
    EXPT.subject(s).functional = sub_funcs;
    
    % (4) motion regressors
    mot_query = dir(fullfile(sub_dir, 'func', ...
        '*task-tomloc*desc-smoothed*.nii'));
    sub_funcs = cellfun(@(f) fullfile('func', f), {func_query.name}, ...
        'UniformOutput', 0);
    EXPT.subject(s).functional = sub_funcs;
end

% Save to file
out_file = fullfile(model_dir, 'task-tomloc_model-localizer_desc-EXPT.mat');
save(out_file, 'EXPT');