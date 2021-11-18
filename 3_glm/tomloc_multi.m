function multi = tomloc_multi(model, subj, run)
%TOMLOC_MULTI Loads model specification from event files
%   Inputs
%       model (int)     # of model to be used (for this task, always 1)
%       sub (int)       subject #
%       run (int)       run #
%
%   Output
%       multi (structure)   Model specification. Fields:
%           names
%           onsets
%           durations
%           pmod.{name, param, poly}

% Read events
in_dir = '/ncf/gershman/Lab/natalia_teaching/BIDS_data';
f_template = fullfile(in_dir, 'sub-%02d', 'func', ...
    'sub-%02d_task-tomloc_run-%02d_events.tsv');
f = sprintf(f_template, subj, subj, run);
fprintf('Reading events from:\n%s', f);

events = readtable(f, 'FileType', 'text');
disp(events);

% Split by trial type
multi = struct('names', {}, 'onsets', {}, 'durations', {});
conditions = unique(events.trial_type);
for c = 1:length(conditions)
    % filter data
    cond = conditions{c};
    cond_events = strcmp(events.trial_type, cond);
    
    % read onsets and durations
    ons = events(cond_events, 'onset');
    dur = events(cond_events, 'duration');
    
    % save to structure
    multi(c).names = cond;
    multi(c).onsets = table2array(ons)';
    multi(c).durations = table2array(dur)';
end

end

