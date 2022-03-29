function EXPT=fun_glm_inputs(task, model, multi)
    % Creates EXPT structure for modeling
    % Reference: github.com/sjgershm/ccnl-fmri/wiki/Creating-the-EXPT-structure
    % Natalia Velez, November 2021

    %% Experiment directories
    data_dir = '/n/gershman_ncf/Lab/natalia_teaching/BIDS_data/derivatives';
    in_dir = fullfile(data_dir, 'model_inputs');

    %% Experiment info
    EXPT.TR = 2;                        % repetition time (seconds)
    EXPT.create_multi = multi;  % handle for function that creates multi structures
    EXPT.inputdir = in_dir; % where to put model inputs
    EXPT.modeldir = strrep(in_dir, 'model_inputs', 'glm'); % output dir
    
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
    fprintf('Including %i participants in analysis\n', length(subs));
    disp(subs);

    %% Subject info
    EXPT.subject = struct('inputdir', {}, 'modeldir', {}, 'functional', {}, ...
        'structural', {}, 'mask', {});
    for s = 1:length(subs)
        sub = subs(s);
        % (1) Output directory
        sub_id = sprintf('sub-%02d', sub);
        sub_dir = fullfile(in_dir, sub_id);
        EXPT.subject(s).inputdir = sub_dir;
        EXPT.subject(s).modeldir = strrep(sub_dir, 'model_inputs', 'glm');
        fprintf('=== #%i: %s ===\n', s, sub_id);
        disp(['Parent directory: ' sub_dir]);
        disp(['Output directory: ' EXPT.subject(s).modeldir]);

        % (2) Structural & mask files
        struct_query = dir(fullfile(sub_dir, 'anat', ...
            '*T1w.nii'));
        EXPT.subject(s).structural = fullfile('anat', struct_query(1).name);
        disp(['Structural: ' EXPT.subject(s).structural]);

        mask_query = dir(fullfile(sub_dir, 'anat', ...
            '*brain_mask.nii'));
        EXPT.subject(s).mask = fullfile('anat', mask_query(1).name);
        disp(['Brain mask: ' EXPT.subject(s).mask]);

        % (3) functional files
        task_str = sprintf('*task-%s*desc-smoothed*.nii', task);
        func_query = dir(fullfile(sub_dir, 'func', task_str));
        sub_funcs = cellfun(@(f) fullfile('func', f), {func_query.name}, ...
            'UniformOutput', 0);
        EXPT.subject(s).functional = sub_funcs;
        fprintf('%i functional files found:\n', length(sub_funcs));
        disp(sub_funcs);

        % (4) motion regressors
        mot_task_str = sprintf('*task-%s*desc-confounds_timeseries.txt', task);
        mot_query = dir(fullfile(sub_dir, 'func', mot_task_str));
        sub_mot = cellfun(@(f) fullfile('func', f), {mot_query.name}, ...
            'UniformOutput', 0);
        EXPT.subject(s).motion = sub_mot;
        fprintf('%i motion files:\n', length(sub_mot));
        disp(sub_mot);
    end

    % Save to file
    out_template = fullfile(in_dir, 'task-%s_model-%s_desc-EXPT.mat');
    out_file = sprintf(out_template, task, model); 
    disp(['Saving EXPT structure to: ' out_file]);
    save(out_file, 'EXPT');
end