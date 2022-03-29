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



% Initialize model specification
empty_cells = {{}};
multi = struct('names', empty_cells, 'onsets', empty_cells, ...
    'durations', empty_cells);
    
% Branch off, depending on value of "model"
if strcmp(model, 'parametric')
    disp('GLM 1: PARAMETRIC REGRESSORS')
    % Read events
    project_dir = '/n/gershman_ncf/Lab/natalia_teaching/BIDS_data/';
    in_dir = fullfile(project_dir, 'derivatives', 'model_events');
    f_template = fullfile(in_dir, 'sub-%02d', 'func', ...
        'sub-%02d_task-teaching_run-%02d_model-main_events.tsv');
    f = sprintf(f_template, subj, subj, run);

    fprintf('Reading events from:\n%s', f);    
    events = readtable(f, 'FileType', 'text');
    disp(events);

    % Get all unique conditions from events file
    conditions = unique(events.trial_type);

    % Add pmod to multi
    pmod_names = {'pTrue', 'KL'}; % param conditions to look out for
    pmod_cells = cell(1,length(conditions));
    pmod = struct('name', pmod_cells, 'param', pmod_cells, ...
        'poly', pmod_cells);
    multi.pmod = pmod;

    for c = 1:length(conditions)
        % filter data
        cond = conditions{c};
        cond_events = strcmp(events.trial_type, cond);

        % read onsets and durations
        ons = events(cond_events, 'onset');
        dur = events(cond_events, 'duration');

        % add parametric regressors to "show" events
        if ismember(cond, pmod_names)
            multi.pmod(c).name = {cond};
            multi.pmod(c).poly = {1};

            % get parameter values
            pmod_table = table2array(events(cond_events, 'value'));
            pmod_vals = str2double(pmod_table);
            multi.pmod(c).param = {pmod_vals'};
        end

        % save to structure
        multi.names{c} = cond;
        multi.onsets{c} = table2array(ons)';
        multi.durations{c} = table2array(dur)';
    end
elseif strcmp(model, 'beta')
    disp('GLM 2: BETA SERIES REGRESSION')
    
    % Read events
    in_dir = '/ncf/gershman/Lab/natalia_teaching/BIDS_data';
    f_template = fullfile(in_dir, 'sub-%02d', 'func', ...
        'sub-%02d_task-teaching_run-%02d_events.tsv');
    f = sprintf(f_template, subj, subj, run);
    fprintf('Reading events from:\n%s', f);
    
    events = readtable(f, 'FileType', 'text');
    disp(events);

    % get all unique events
    conditions = unique(events.trial_type);
    
    % separate condition labels for each 'show' event
    show_events = strcmp(events.trial_type, 'show');
    show_conditions = arrayfun(@(x) sprintf('show_run-%02d_trial-%02d', run, x), ...
                      1:sum(show_events), 'UniformOutput', false);
    conditions(strcmp(conditions, 'show')) = []; % remove single "show" event
    disp(conditions);
    
    % assemble all normal condition regressors
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
    
    % assemble "show" trial regressors    
    show_start=length(conditions)+1;
    show_end=length(conditions)+sum(show_events); % get ranges for indexing
    multi.names(show_start:show_end) = show_conditions;
    multi.onsets(show_start:show_end) = table2cell(events(show_events, 'onset'));
    multi.durations(show_start:show_end) = table2cell(events(show_events, 'duration'));
    
end 
end