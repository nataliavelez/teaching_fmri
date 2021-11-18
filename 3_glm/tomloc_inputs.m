% 1_TOMLOC_INPUTS
% Creates EXPT structure for modeling tomloc task
% Reference: github.com/sjgershm/ccnl-fmri/wiki/Creating-the-EXPT-structure
% Natalia Velez, November 2021

%% Experiment directories
data_dir = '/ncf/gershman/Lab/natalia_teaching/BIDS_data/derivatives';
fmriprep_dir = fullfile(data_dir, 'fmriprep');
smooth_dir = fullfile(data_dir, 'smooth_fmriprep'); 
out_dir = fullfile(data_dir, 'modelspec');

%% Experiment info
EXPT.TR = 2;                        % repetition time (seconds)
EXPT.create_multi = @tomloc_multi;  % handle for function that creates multi structures
EXPT.modeldir = out_dir; % where to put model results

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
EXPT.subject = struct('datadir', {}, 'functional', {}, ...
    'structural', {}, 'mask', {});

for s=subs(1:3)
    fprintf('\n==== sub-%02d ====', s);
    % (1) Output directory
    subID = sprintf('sub-%02d', s);
    EXPT.subject(s).datadir = fullfile(out_dir, subID);
    fprintf('\nLoading inputs from: %s',  EXPT.subject(s).datadir);

    % (2) Functional files
    functionals = dir(fullfile(out_dir, subID, 'func', '*task-tomloc*smoothed*.nii'));
    functionals = cellfun(@(f) fullfile('func', f), {functionals.name}, ...
        'UniformOutput', 0);

    % Sort functionals by run #
    run_no = cellfun(@(f) regexp(f, '(?<=run-)([0-9]+)', 'match'),  ...
        functionals, 'UniformOutput', 0);
    run_no = vertcat(run_no{:});
    run_no = cellfun(@str2num, run_no);
    functionals = functionals(run_no);

    % Add to struct
    EXPT.subject(s).functional = functionals;
    fprintf('\nFunctional files:\n');
    for f = EXPT.subject(s).functional
        disp(f{1});
    end

    % (3) Structural & mask files
    mask = dir(fullfile(out_dir, subID, 'anat', '*desc-brain_mask.nii'));
    EXPT.subject(s).mask = fullfile('anat', mask(1).name);
    fprintf('Mask: %s', EXPT.subject(s).mask);

    struct = dir(fullfile(out_dir, subID, 'anat', '*desc-preproc_T1w.nii'));
    EXPT.subject(s).structural = fullfile('anat', struct(1).name);
    fprintf('\nStructural: %s\n', EXPT.subject(s).structural);
end

% Save to file
fprintf('\nDone! Saving EXPT structure\n');
save(fullfile(out_dir, 'task-tomloc_model-localizer_expt.mat'), 'EXPT');