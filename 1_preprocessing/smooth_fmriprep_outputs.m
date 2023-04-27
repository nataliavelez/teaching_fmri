function smooth_fmriprep_outputs(sub)
% SMOOTH_FMRIPREP_OUTPUTS fmriprep doesn't support smoothing, so we'll 
% do it ourselves!
% Natalia Velez, November 2021

%% Experiment parameters
data_dir = '/ncf/gershman/Lab/natalia_teaching/BIDS_data';
fmriprep_dir = fullfile(data_dir, 'derivatives', 'fmriprep');
smooth_dir = fullfile(data_dir, 'derivatives', 'model_inputs');
sub_id = sprintf('sub-%02d', sub);
out_dir = fullfile(smooth_dir, sub_id, 'func');

% Make output directory
fprintf('Saving outputs to: %s\n', out_dir);
if ~exist(out_dir, 'dir')
    disp('Created new folder');
    mkdir(out_dir);
end

%% Copy fmriprep outputs to smoothing folder
% Find preprocessed functionals
in_query = fullfile(fmriprep_dir, sub_id, 'func', ...
    '*MNI152NLin2009cAsym_desc-preproc_bold.nii.gz');
in_file_search = dir(in_query);
in_originals = cellfun(@(dir, f) fullfile(dir, f), {in_file_search.folder}, ...
    {in_file_search.name}, 'UniformOutput', 0);

% Unzip functionals into new folder
disp('Unzipping functionals...');
gunzip(in_originals, out_dir);
in_files = strrep(in_originals, fmriprep_dir, smooth_dir);
in_files = strrep(in_files, '.nii.gz', '.nii'); % list of unzipped functionals

%% Run smoothing job
% SPM defaults
def = spm_get_defaults;

% Output files
fwhm = def.smooth.fwhm;
out_files = strrep(in_files, 'desc-preproc', ...
    sprintf('desc-smoothed_fwhm-%imm', fwhm(1)));

% Putting it all together
disp('Smoothing functional files...')
for f = 1:length(in_files)
    fprintf('(%i/%i) %s \n', f, length(in_files), out_files{f});
    spm_smooth(in_files{f}, out_files{f}, fwhm);
    
end
end