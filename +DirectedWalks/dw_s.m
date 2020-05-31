ACOPF_SEED = '.data/case14_ACOPF.csv';
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));

dist = @(x,y) sqrt(sum(x .* y));
[N,dim] = size(acopfResults);

% constants - from config file
MU = 0.01; % step size
R = 1.5; % max(dist(acopfResults))/2 ? knn nearest neighbour? -> largest radius / 2

%

% parfor i = 1:N
%     
%     
% end

import DirectedWalks.checkSetpoint
% S already checked if feasible or not?
% assumption: S feasible
S = acopfResults{1,:};
L = S;
% it can be +/-
L(1) = L(1) + S;
%checkSetpoint(S... 





