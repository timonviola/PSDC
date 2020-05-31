clear
t = tic;
load +test\debug_const.mat
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
% Check all SP's small signal stability
% Progressbar that shows on STDOUT
pw = textBar(N,'Parallel Directed walks');
t2 = tic;
for i = 1:N
    [stable(i), classDetails{i}, dampingRatio(i)] = ...
        DirectedWalks.checkSetpoint(dwResults{i,:},PSAT_FILE,CASE_FILE);
    increment(pw)
end
delete(pw)
toc(t2)
save('data_set_points_acopf2.mat','stable','classDetails','dampingRatio')

%% print
util.printDataSummary