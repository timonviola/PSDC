ACOPF_SEED = 'set_points_case9_1.csv';
CASE_FILE = 'case_files/case9.m';
PSAT_FILE = 'case_files/d_009_dyn.m';
%
%res = readtable('set_points_casecase9_1.csv','ReadVariableNames',false);
res = [];
fl = dir('./*casecase9_*.csv');
N = size(fl,1);
disp(['Concatenating ' num2str(N) ' files.'])
for i = 1:N
	res = [res; readtable(fl(i).name,'ReadVariableNames',false)];
end
writematrix(res{:,:}, 'unified_case9.csv')
util.add_dependencies
util.dataSummary('unified_case9.csv', PSAT_FILE, CASE_FILE)
