% parallel directed walks
t2 = tic;
ACOPF_SEED = '.data/case9_2020_06_03T162628Z/case9_ACOPF.csv';
PSAT_FILE = ['case_files' filesep 'd_009_dyn.m'];
CASE_NAME = 'case9';
CASE_FILE = [pwd filesep 'case_files' filesep CASE_NAME '.m'];

acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
% Sort columns
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));

% Check for repeated data in acopfResults:
[C, ia, ic]= unique(acopfResults,'stable');
if size(C) == size(acopfResults)
    warning('some acopf values are doubled')
end
% boolean classification - feasible = 1, infeasible = 0
% N = size(acopfResults,1);
N = 10;
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
    clust=parcluster(dccClusterProfile());
    numw = 100;
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


%% Add first set to data-set
% Progressbar that shows on STDOUT
pw = textBar(N,'Parallel Directed walks');
parfor i = 1:N
    writematrix( ...
        DirectedWalks.dwf_f(acopfResults{i,:},PSAT_FILE,CASE_FILE),...
        ['set_points_case' CASE_NAME '_' num2str(i) '.csv']);
   increment(pw)
end


toc(t2)
delete(pw)

% TODO: concatenate all csv files
% send to final check -> m3.m
