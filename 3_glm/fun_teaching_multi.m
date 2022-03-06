function multi = fun_teaching_multi(model, subj, run)
%FUN_TEACHING_MULTI Creates model specification for GLMs used on teaching task
%   Inputs
%       model (int)     # of model to be used (for this task)
%            1: parametric regressors (for univariate analyses)
%            2: beta series (for multivariate analyses)
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
    'sub-%02d_task-teaching_run-%02d_events.tsv');
f = sprintf(f_template, subj, subj, run);
fprintf('Reading events from:\n%s', f);

events = readtable(f, 'FileType', 'text');
disp(events);

% Create model specification
empty_cells = {{}};
multi = struct('names', empty_cells, 'onsets', empty_cells, ...
    'durations', empty_cells);
    
% Branch off, depending on vlaue of "model"
if model == 1
    disp('GLM 1: PARAMETRIC REGRESSORS')
    conditions = unique(events.trial_type);
    for c = 1:length(conditions)
        % filter data
        cond = conditions{c};
        cond_events = strcmp(events.trial_type, cond);

        % read onsets and durations
        ons = events(cond_events, 'onset');
        dur = events(cond_events, 'duration');

        % save to structure
        multi.names{c} = cond;
        multi.onsets{c} = table2array(ons)';
        multi.durations{c} = table2array(dur)';
    end
elseif model == 2
    disp('GLM 2: BETA SERIES REGRESSION')
    % get all unique events
    conditions = unique(events.trial_type);
    
    % make a unique regressor for each 'show' event
    n_show_events = sum(strcmp(events.trial_type, 'show'));
    show_conditions = arrayfun(@(x) sprintf('show_run-%02d_trial-%02d', run, x), ...
                      1:n_show_events, 'UniformOutput', false);
    conditions(strcmp(conditions, 'show')) = []; % remove single "show" event
    conditions = [conditions; shjow_conditions]; % replace with trial-wise regressors    
 
    % get onsets, durations for show events specifically
    
    
end 
end