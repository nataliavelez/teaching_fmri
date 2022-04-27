% Placeholder inputs
model=1;
subj=1;
run=1;

% Load model predictions
% Read events
project_dir = '/n/gershman_ncf/Lab/natalia_teaching/BIDS_data/';
in_dir = fullfile(project_dir, 'derivatives', 'model_events');
f_template = fullfile(in_dir, 'sub-%02d', 'func', ...
    'sub-%02d_task-teaching_run-%02d_model-main_events.tsv');
f = sprintf(f_template, subj, subj, run);
fprintf('Reading events from:\n%s', f);

events = readtable(f, 'FileType', 'text');
disp(events);

