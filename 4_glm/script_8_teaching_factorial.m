%% script_3_teaching_beta.m
% Natalia Velez, April 2022
% Run second-level covariates for teaching task

% Load SPM defaults
spm('defaults', 'FMRI');

% Experiment directories
model = 'task-teaching_model-parametric';
project_dir = '/n/gershman_ncf/Lab/natalia_teaching';
data_dir = fullfile(project_dir, 'BIDS_data');
analysis_dir = fullfile(project_dir, 'analysis');
glm_dir = fullfile(data_dir, 'derivatives', 'glm');
group_dir = fullfile(glm_dir, 'group', model);
out_parent = fullfile(group_dir, 'covariates');
mkdir(out_parent);

% Load contrasts
load(fullfile(group_dir, 'contrasts.mat'), 'contrasts');
n_con = length(contrasts);

% Assemble separate jobs for each contrast
for c = 1:n_con

    % Get contrast name
    con_name = strrep(contrasts{c}, '+', '');
    fprintf('====== Contrast: %s ======\n', con_name);
    
    % Make output directory
    out_dir = sprintf(fullfile(out_parent, 'con_%04d'), c);
    fprintf('Saving outputs to: %s\n', out_dir);
    mkdir(out_dir);
    
    % Create job with three steps
    % (1) Specify factorial design
    % (2) Model estimation
    % (3) Contrast
    job = cell(1,3);
    
    % (1) Factorial design
    % Search for scan files
    scans_template = fullfile(glm_dir, 'sub-*', 'func', model, ... 
        sprintf('con_%04d.nii', c));
    scans_query = dir(scans_template);
    scan_files = fullfile({scans_query.folder}, {scans_query.name});
    
    % Load covariates
    cov_file = fullfile(analysis_dir, '2_behavioral', 'outputs', ...
        'second_level_model_regressors.csv');
    cov_table = readtable(cov_file);
    cov = cov_table.logBF;
    
    % Add to job
    job{1}.spm.stats.factorial_design.dir = {out_dir};
    job{1}.spm.stats.factorial_design.des.mreg.scans = scan_files';
    job{1}.spm.stats.factorial_design.des.mreg.mcov.c = cov;
    job{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'logBF';
    
    % Anddd a bunch of defaults
    job{1}.spm.stats.factorial_design.des.mreg.mcov.iCC = 1;
    job{1}.spm.stats.factorial_design.des.mreg.incint = 1;
    job{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    job{1}.spm.stats.factorial_design.masking.im = 1;
    job{1}.spm.stats.factorial_design.masking.em = {''};
    job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    job{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    
    % (2) Model estimation
    SPM_file = fullfile(out_dir, 'SPM.mat');
    job{2}.spm.stats.fmri_est.spmmat = {SPM_file};
    job{2}.spm.stats.fmri_est.write_residuals = 1;
    job{2}.spm.stats.fmri_est.method.Classical = 1;
    
    % (3) Contrasts
    job{3}.spm.stats.con.spmmat = {SPM_file};
    job{3}.spm.stats.con.consess{1}.tcon.name = sprintf('logBF x %s', con_name);
    job{3}.spm.stats.con.consess{1}.tcon.weights = [0 1];
    job{3}.spm.stats.con.delete = 1;
    
    % Run job!
    spm_jobman('run', job);
end
close all;