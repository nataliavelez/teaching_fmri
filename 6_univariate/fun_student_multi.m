function multi = fun_student_multi(model, subj, run)
%FUN_STUDENT_MULTI Creates model specification for empirical GLMs used on
%teaching task
%   Inputs
%       model (str)     name of model
%            student: main empirical GLM
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
    
% Read events
project_dir = '/n/gershman_ncf/Lab/natalia_teaching/BIDS_data/';
in_dir = fullfile(project_dir, 'derivatives', 'model_events');
f_template = fullfile(in_dir, 'sub-%02d', 'func', ...
    'sub-%02d_task-teaching_run-%02d_model-empirical_events.tsv');
f = sprintf(f_template, subj, subj, run);

fprintf('Reading events from:\n%s', f);
events = readtable(f, 'FileType', 'text');
disp(events);

% Get all unique conditions from events file
all_conditions = unique(events.trial_type);
pmod_names = {'pTrue', 'KL'}; % param conditions to look out for
conditions = setdiff(all_conditions, pmod_names); % valid conds

% Add pmod to multi
empty_pmod_cells = cell(1,length(conditions));
pmod_cells = cell(1, length(pmod_names));
pmod = struct('name', empty_pmod_cells, 'param', empty_pmod_cells, ...
    'poly', empty_pmod_cells);
multi.pmod = pmod;


for c = 1:length(conditions)
    % filter data
    cond = conditions{c};
    cond_events = strcmp(events.trial_type, cond);

    % read onsets and durations
    ons = events(cond_events, 'onset');
    dur = events(cond_events, 'duration');

    % add parametric regressors to "show" events
    if strcmp(cond, 'show_new')
        % Initialize parametric modulators for "show" events
        multi.pmod(c).name = pmod_cells;
        multi.pmod(c).param = pmod_cells;
        multi.pmod(c).poly = num2cell(ones(1, length(pmod_names)));

        % Fill in values of parametric regressors
        for p = 1:length(pmod_names)
            p_name = pmod_names{p};
            multi.pmod(c).name{p} = p_name;

            pmod_events = strcmp(events.trial_type, p_name);
            pmod_table = table2array(events(pmod_events, 'value'));
            pmod_vals = str2double(pmod_table);
            multi.pmod(c).param{p} = pmod_vals';
        end
    end

    % save to structure
    multi.names{c} = cond;
    multi.onsets{c} = table2array(ons)';
    multi.durations{c} = table2array(dur)';
end

% Turn off orthogonalization
dims = size(multi.onsets);
orth = zeros(dims);
multi.orth = num2cell(orth);

end