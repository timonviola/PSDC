clear
t = tic;

% ACOPF_SEED = '.data/case14_ACOPF.csv';
% CASE_FILE = 'case_files/case14.m';
% PSAT_FILE = 'case_files/d_014_dyn_mdl_pretty.m';
ACOPF_SEED = '.data/case9_2020_06_03T162628Z/case9_ACOPF.csv'; %'set_points_case9_58.csv';%'set_points_case9_100.csv';%.data/case9_ACOPF.csv';
CASE_FILE = 'case_files/case9.m';
PSAT_FILE = 'case_files/d_009_dyn.m';

% df = 'set_points_2.csv';
% % columns are sorted already
% dwResults = readtable(df, 'ReadVariableNames',false);
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
% Sort columns
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));
dwResults = acopfResults;






% Check for repeated data
[C, ia, ic]= unique(dwResults,'stable');

if size(C) == size(dwResults)
    warning('some values are doubled')
else
    fprintf('No duplicate values.\n')
end

toc(t)

N = size(dwResults,1);
stable = nan(N,1);
% criteria fail/pass details [PG QG VM S_{flow}]
classDetails = cell(N,1);
% damping ratios (stored separately for easier access)
dampingRatio = nan(N,1);


% Set up cluster
% if ispc
%     if isempty(gcp)
%         p = parpool('nocreate');
%     else
%         p = gcp();
%     end
% else
%     % load the default cluster profile
%     clust=parcluster(dccClusterProfile());
%     numw = 16;
%     p = parpool(clust, numw);
% end
% disp(p)
% 
% if ispc
%     p.addAttachedFiles('c:\Users\Timon\myPSAT\psat\');
% else
%     p.addAttachedFiles('~/thesis/psat/');
%     p.addAttachedFiles('~/thesis/textBar/textBar.m');
% end
% p.addAttachedFiles(PSAT_FILE);
% p.addAttachedFiles(CASE_FILE);




% Check all SP's small signal stability
% Progressbar that shows on STDOUT
pw = textBar(N,'Parallel checks');


t2 = tic;
for i = 1:N
    [stable(i), classDetails{i}, dampingRatio(i)] = ...
        DirectedWalks.checkSetpoint(dwResults{i,:},PSAT_FILE,CASE_FILE);
    increment(pw)
end
delete(pw)
toc(t2)
save('data_set_points_dw1.mat','stable','classDetails','dampingRatio')

%% print
util.printDataSummary
