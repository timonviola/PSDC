OUT_DIR = '.data/case14_dwg/';
%ACOPF_SEED = [OUT_DIR 'case39_ACOPF.csv'];
CASE_FILE = 'case_files/case14.m';
PSAT_FILE = 'case_files/case14_matpower_limits.m';

fprintf('OUT_DIR: %s\n',OUT_DIR);
res = [];
fl = dir([OUT_DIR 'dw_set_pointscase*.csv']);
N = size(fl,1);
disp(['Concatenating ' num2str(N) ' files.'])
for i = 1:N
	res = [res; readtable([OUT_DIR fl(i).name],'ReadVariableNames',false)];
end
writematrix(res{:,:}, [OUT_DIR 'unified_case14.csv'])
util.add_dependencies

util.dataSummary([ OUT_DIR 'unified_case14.csv'], PSAT_FILE, CASE_FILE, 0.03)
%util.dataSummary(ACOPF_SEED, PSAT_FILE, CASE_FILE,'readTableVariables' true)
