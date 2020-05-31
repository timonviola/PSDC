clear
t = tic;
%% Load matpower case
% MATPOWER file name    (opf data)
CASE_NAME = 'case14';
CASE_FILE = 'C:\Users\Timon\OneDrive - Danmarks Tekniske Universitet\Denmark\DTU\2019_20_II\software\case14.m';
% PSAT file name        (dynamic data)
PSAT_FILE = 'case_files\d_014_dyn_mdl_pretty.m';
% get current timestamp
TS = timestamp;

%%
fprintf(pad(['Load casefile ' CASE_NAME ' '],50,'right','.'))
mpc = loadcase(CASE_FILE);
fprintf('[ OK ]\n')

%% Run bound tightening - voltage and angle differences
% Bound tightening algorightm
%   Reference: https://github.com/dmitry-shchetinin/BTOPF
options.bounds = 1; % tighten both voltage and angle differences

fprintf(pad('Run BT ',50,'right','.'))
warning off
[mpc, info] = tighten_bounds(mpc, options);
warning on
fprintf('[ OK ]\n')
% Define file name with EXTENSION
btFile = ['.data\' CASE_NAME '_tightened' TS '.m'];

fprintf(pad(['Save BT model ' btFile ' '],50,'right','.'))
savecase(btFile, mpc)
fprintf('[ OK ]\n')
toc(t)

%% Bound tightening & Quadratic Convex relaxation of ACOPF
%   "Iteratively tighten bounds on voltage magnitude and phase-angle
%   difference variables."

% PSDC home folder \data\
hF = [pwd '\.data\'];
% Separating planes of polytope
N_ITERATIONS = 1000;
% Number of uniform samples from the polytope
N_SAMPLES=1000;
% Output file name (containing the uniformly distributed samples
OUT_FILE_NAME_SAMPLES=[hF CASE_NAME '_QCRM_' num2str(N_ITERATIONS) '.csv'];
% System call to start julia
stat = system(['julia qc_relaxation.jl "'  btFile '" "'...
    num2str(N_ITERATIONS) '" "' OUT_FILE_NAME_SAMPLES '"  "'...
    num2str(N_SAMPLES) '"']);
if stat
    error('PSDC:julia','Something went wrong.')
end

%% ACOPF checks on samples
% Run a modified ACOPF on all the samples

% Output file of acopf setpoints
ACOPF_SEED = [hF CASE_NAME '_ACOPF.csv'];
% Run N_SAMPLES AC-OPF on the setpoints OUT_FILE_NAME_SAMPLES
% System call to start julia
stat = system(['julia opf_par.jl "' ACOPF_SEED '" "' CASE_FILE '" "' ...
    OUT_FILE_NAME_SAMPLES]);
if stat
    error('PSDC:julia','Something went wrong.')
end
% Load the samples TODO: LODAD AS DISTRIBUTED ARRAY
% https://se.mathworks.com/help/parallel-computing/distributing-arrays-to-parallel-workers.html
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
% Sort columns
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));

% Check for repeated data in acopfResults:
[C, ia, ic]= unique(acopfResults,'stable');
if size(C) == size(acopfResults)
    warning('some acopf values are doubled')
end
toc(t)
fprintf('All done\n')


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






