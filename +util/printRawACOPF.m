% Copyright (C) 2020 Timon Viola

load +test\debug_const.mat
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));

idx = find(stable);
stableR = acopfResults(idx,:);

summary(stableR)

% histogram(stableR.PG2,100);


