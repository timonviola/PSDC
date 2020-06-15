%% test directed walk brute force function
ACOPF_SEED = '.data/case9_2020_06_03T162628Z/case9_ACOPF.csv';%'.data/case9_ACOPF.csv';
CASE_FILE = 'case_files/case9.m';
PSAT_FILE = 'case_files/d_009_dyn.m';
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));
setPoint = acopfResults{68,:};

fprintf(pad('Run directed walk',50,'right','.'))
dwSetPoints = DirectedWalks.dwf_f(setPoint, PSAT_FILE, CASE_FILE);
fprintf('[ OK ]\n')

% compare with saved data
load('DirectedWalks/dwfTestPoints.mat','testPoints');
 
fprintf(pad('Check data consistency',50,'right','.'))
assert(isequal(dwSetPoints, testPoints),'Returned data is not the same as reference.')
fprintf('[ OK ]\n')
fprintf(pad('All cases passed',50,'right','.'))
fprintf('<strong> Pass</strong>\n')