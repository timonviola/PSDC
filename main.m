clear
t = tic;
CASE_NAME = 'case14';
CASE_FILE = 'C:\Users\Timon\OneDrive - Danmarks Tekniske Universitet\Denmark\DTU\2019_20_II\software\case14.m';
PSAT_FILE = 'case_files\d_014_dyn_mdl_pretty.m';
TS = timestamp;
btFile = ['.data\' CASE_NAME '_tightened' TS '.m'];
% Separating planes of polytope
N_ITERATIONS = 1000;
% Number of uniform samples from the polytope
N_SAMPLES=1000;

% bt 1
mpc = loadcase(CASE_FILE);
options.bounds = 1;
warning off
[mpc, info] = tighten_bounds(mpc, options);
warning on
savecase(btFile, mpc)
fprintf('BT #1 - '); toc(t)

% bt2 + QC 
tbt2 = tic;
hF = [pwd '\.data\'];
OUT_FILE_NAME_SAMPLES=[hF CASE_NAME '_QCRM_' num2str(N_ITERATIONS) '.csv'];
stat = system(['julia qc_relaxation.jl "'  btFile '" "'...
    num2str(N_ITERATIONS) '" "' OUT_FILE_NAME_SAMPLES '"  "'...
    num2str(N_SAMPLES) '"']);
if stat
    error('PSDC:julia','Something went wrong.')
end
% acopf checks
ACOPF_SEED = [hF CASE_NAME '_ACOPF.csv'];
stat = system(['julia opf_par.jl "' ACOPF_SEED '" "' CASE_FILE '" "' ...
    OUT_FILE_NAME_SAMPLES]);
if stat
    error('PSDC:julia','Something went wrong.')
end
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));
[C, ia, ic]= unique(acopfResults,'stable');
if size(C) == size(acopfResults)
    warning('some acopf values are doubled')
end
fprintf('BT #2 QC - '); toc(tbt2)
fprintf('Total - '); toc(t)

% SSS, Directed walks
tsss = tic;
N = size(acopfResults,1);
stable = nan(N,1);
classDetails = cell(N,1);
dampingRatio = nan(N,1);
if ispc
    if isempty(gcp)
        p = parpool('nocreate');
    else
        p = gcp();
    end
else
    clust=parcluster(dccClusterProfile());
    numw = 100;
    p = parpool(clust, numw);
end
if ispc
    p.addAttachedFiles('c:\Users\Timon\myPSAT\psat\');
else
    p.addAttachedFiles('~/thesis/psat/');
end
p.addAttachedFiles(PSAT_FILE);
p.addAttachedFiles(CASE_FILE);
pw = textBar(N,'Parallel Directed walks');
parfor i = 1:N
    [stable(i), classDetails{i}, dampingRatio(i)] = ...
        DirectedWalks.checkSetpoint(acopfResults{i,:},PSAT_FILE,CASE_FILE);
    increment(pw)
end
delete(pw)

fprintf('DW - '); toc(tsss)
fprintf('Total - '); toc(t)
save([CASE_NAME '_final_results_' TS '.csv'],'stable','classDetails',...
    'dampingRatio')






