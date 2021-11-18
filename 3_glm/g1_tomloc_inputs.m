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
EXPT.subject = struct('modeldir', {}, 'functional', {}, ...
    'structural', {}, 'mask', {});
s = subs(1);

% (1) Output directory
subID = sprintf('sub-%02d', s);
EXPT.subject(s).modeldir = fullfile(out_dir, subID, 'func');

% (2) Structural & mask files


% EXPT.subject(1).datadir = 'subject1';                     % where the data are stored
% EXPT.subject(1).functional = {'run001.nii' 'run002.nii'}; % functional (EPI) nifti files
% EXPT.subject(1).structural = 'struct.nii';                % structural (T1) nifti files
% EXPT.subject(2).datadir = 'subject2';                     
% EXPT.subject(2).functional = {'run001.nii' 'run002.nii'};
% EXPT.subject(2).structural = 'struct.nii';          