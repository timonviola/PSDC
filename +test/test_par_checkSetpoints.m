%
% Copyright (C) 2020 Timon Viola

load(['+test' filesep 'debug_const.mat'])
t2 = tic;
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames)); % sort columns
% N = size(acopfResults,1);
N = 100;
stable = nan(N,1);      
classDetails = cell(N,1);                      
dampingRatio = nan(N,1);

% Set up cluster
if ispc
    if isempty(gcp)
        p = parpool('nocreate');
    else
        p = gcp();
    end
else
    clust=parcluster(dccClusterProfile());    % load the default cluster profile
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

pw = textBar(N,'cluster_test');
parfor i = 1:N
    [stable(i), classDetails{i}, dampingRatio(i)] = DirectedWalks.checkSetpoint(acopfResults{i,:},PSAT_FILE,CASE_FILE);
    increment(pw)
end


toc(t2)
delete(pw)
