% Add mfit to working directory
mfit_dir = '/n/gershman_ncf/User/nvelezalicea/mfit';
addpath(mfit_dir);

% Search for model fitting results
model_dir = 'outputs/simulated_model_comparison';
evidence_files = dir(fullfile(model_dir, '*evidence.txt'));

% Model recovery
for i=1:length(evidence_files)
    in_f = fullfile(evidence_files(i).folder, evidence_files(i).name);
    mtx = load(in_f);
    [alpha, exp_r, xp, pxp, bor, g] = bms(mtx);
    
    out_f = strrep(in_f, 'evidence.txt', 'pxp.txt');
    writematrix(pxp, out_f)
end

% Human PXP
human_in = 'outputs/human_model_comparison/human_model_evidence.txt';
mtx = load(human_in);
[alpha, exp_r, xp, pxp, bor, g] = bms(mtx);
pxp_out = strrep(human_in, 'evidence.txt', 'pxp.txt');
alpha_out = strrep(pxp_out, 'pxp', 'alpha');
g_out = strrep(pxp_out, 'pxp', 'posterior');

% Save outputs
writematrix(pxp, pxp_out);
writematrix(alpha, alpha_out);
writematrix(g, g_out);