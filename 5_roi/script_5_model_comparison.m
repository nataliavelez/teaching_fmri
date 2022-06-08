%% script_5_model_comparison
% Natalia Velez May 2022
% Compute PXPs for GLMs

%% (1) Setup
% Add mfit to working directory
mfit_dir = '/n/gershman_ncf/User/nvelezalicea/mfit';
addpath(mfit_dir);

% Find model outputs
model_file = fullfile('outputs', 'glm_model_evidences.mat');
load(model_file, 'model_evidences');

%% (2) Iterate over GLMs
for r = 1:length(model_evidences)
    % concat evidence for all models
    evidences = [model_evidences(r).models(:).bic];
    missing_subjs = any(isnan(evidences), 2); % drop subjs missing ROI
    evidences(missing_subjs, :) = [];
    
    % model comparison
    [alpha, exp_r, xp, pxp, bor, g] = bms(evidences);

    % sanity check: also exclude non-parametric baseline
    param_evidences = evidences(:, 2:4);
    [p_alpha, p_exp_r, p_xp, p_pxp, p_bor, p_g] = bms(param_evidences);

    % save results
    model_evidences(r).model_comparison = struct('mode', ...
        {'all_glms, parametric_glms'}, 'pxp', {pxp, p_pxp}, ...
        'exp_r', {exp_r, p_exp_r}, 'bor', {bor, p_bor}, 'g', {g, p_g});
end

% clean up outputs
model_comparison = model_evidences(:);
save('glm_model_comparison.mat', 'model_comparison');

% save table of pxp
mtx = zeros(length(model_comparison), 4);
param_mtx = mtx(:, 2:4);
post_mtx = zeros(size(mtx));
post_param_mtx = zeros(size(param_mtx));

for r = 1:length(model_comparison)
    mtx(r,:) = model_comparison(r).model_comparison(1).pxp;
    param_mtx(r,:) = model_comparison(r).model_comparison(2).pxp;

    post_mtx(r,:) = model_comparison(r).model_comparison(1).exp_r;
    post_param_mtx(r,:) = model_comparison(r).model_comparison(2).exp_r;
end

model_names = {model_comparison(1).models(:).model_name};
roi_names = {model_comparison(:).roi_name};
all_table = array2table(mtx, 'VariableNames', model_names, ...
    'RowNames', roi_names);
param_table = array2table(param_mtx, 'VariableNames', model_names(2:4), ...
    'RowNames', roi_names);

exp_table = array2table(post_mtx, 'VariableNames', model_names, ...
    'RowNames', roi_names);
exp_param_table = array2table(post_param_mtx, 'VariableNames', model_names(2:4), ...
    'RowNames', roi_names);

writetable(all_table, 'outputs/model_comparison_all.csv', ...
    'WriteRowNames', true);
writetable(param_table, 'outputs/model_comparison_parametric.csv', ...
    'WriteRowNames', true);
writetable(exp_table, 'outputs/model_comparison_all_expr.csv', ...
    'WriteRowNames', true);
writetable(exp_param_table, 'outputs/model_comparison_parametric_expr.csv', ...
    'WriteRowNames', true);