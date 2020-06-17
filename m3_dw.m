% parallel directed walks
t2 = tic;
OUT_DIR =  '.data/case39_2020_06_16T103242Z/';
ACOPF_SEED = [OUT_DIR 'case39_ACOPF.csv'];
PSAT_FILE = ['case_files' filesep 'case39.m'];
CASE_NAME = 'case39';
CASE_FILE = [pwd filesep 'case_files' filesep 'd_case39.m'];
if ~ispc
    util.add_dependencies
end
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
% Sort columns
acopfResults = acopfResults(:,util.natsort(acopfResults.Properties.VariableNames));

% Check for repeated data in acopfResults:
[C, ia, ic]= unique(acopfResults,'stable');
if size(C) == size(acopfResults)
    warning('some acopf values are doubled')
end
% boolean classification - feasible = 1, infeasible = 0
N = size(acopfResults,1);

stable = nan(N,1);
% criteria fail/pass details [PG QG VM S_{flow}]
classDetails = cell(N,1);
% damping ratios (stored separately for easier access)
dampingRatio = nan(N,1);

% Set up cluster
if ispc
    if isempty(gcp)
        p = parpool('nocreate');
    else
        p = gcp();
    end
else
    % load the default cluster profile
    clust=parcluster('clusterProfileElektro2019');
    numw = 64;
    p = parpool(clust, numw);
end
disp(p)

if ispc
    p.addAttachedFiles('c:\Users\Timon\myPSAT\psat\');
else
    p.addAttachedFiles('~/thesis/psat/');
end
p.addAttachedFiles(PSAT_FILE);
p.addAttachedFiles(CASE_FILE);

%% TODO: check for duplicates

%% Add first set to data-set
% Progressbar that shows on STDOUT
pw = textBar(N,'Parallel Directed walks');
parfor i = 1:N
    writematrix( ...
        DirectedWalks.dwg_f(acopfResults{i,:},PSAT_FILE,CASE_FILE),...
        [OUT_DIR 'dw_set_points' CASE_NAME '_' num2str(i) '.csv']);
   increment(pw)
end


toc(t2)
delete(pw)

% TODO: concatenate all csv files
% send to final check -> m3.m
