% this is more like m4 - after directed walks we check for everything
%% SSS, Directed walks
% Check each setpoint from the previous section. The following criteria has
% to be satisfied to add to the data set as a feasible point (1):
%   o  ACOPF limits are not violated
%   o  SSS is satisfied Sigma_{max} <= \Zets_{min}
%   o  N-1 criteria holds (the above listed are true for all N-1 cases).
% If any of these are violated the set point is labeld as infeasible(0).
%
% Setpoint definition:
% As PowerModels and PSAT both stores variables in unordered fashion an
% internal sorting is performed thus the PG and VG setpoint data can be
% passed as simple vectors.
% The internal sorting will assign the right values to each generator eg.:
%   define setpoints as [.3 .4 .2. .4, 1.1 1.01 1.02 .98]
%                       [    PG      ,        VG        ]
% DIRECTEDWALKS.CHECKSETPOINT will sort the psat generators and assign the
% right values e.g: first generator wll be PG = .3, VG = 1.1
%                   second gen      	   PG = .4, VG = 1.01 etc.
%

t2 = tic;
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
    [stable(i), classDetails{i}, dampingRatio(i)] = ...
        DirectedWalks.checkSetpoint(acopfResults{i,:},PSAT_FILE,CASE_FILE);
    increment(pw)
end


toc(t2)
delete(pw)