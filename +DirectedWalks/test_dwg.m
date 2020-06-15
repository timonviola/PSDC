%% test directed walk greedy function
ACOPF_SEED = '.data/case14_2020_06_08T110325Z/case14_ACOPF.csv';
CASE_FILE = 'case_files/case14.m';
PSAT_FILE = 'case_files\case14_matpower_limits.m';

acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));
setPoint = acopfResults{100,:};

fprintf(pad('Run directed walk',50,'right','.'))
dwSetPoints = DirectedWalks.dwg_f(setPoint, PSAT_FILE, CASE_FILE);
fprintf('[ OK ]\n')

% compare with saved data
load('DirectedWalks/dwgTestPoints.mat','testPoints');
 
fprintf(pad('Check data consistency',50,'right','.'))
assert(isequal(dwSetPoints, testPoints),'Returned data is not the same as reference.')
fprintf('[ OK ]\n')
fprintf(pad('All cases passed',50,'right','.'))
fprintf('<strong> Pass</strong>\n')