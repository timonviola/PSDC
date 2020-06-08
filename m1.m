clear
if ~ispc
    util.add_dependencies
end
t = tic;
% MATPOWER case files
% other case files:
% 'case39';
% 'case14';
% 'case9';
CASE_NAME = 'case14';
CASE_FILE = [pwd filesep 'case_files' filesep CASE_NAME '.m'];
% PSAT file name        (dynamic data)
% other possible case files:
%   'd_IEEE39bus.m'];
%   'd_014_dyn_mdl_pretty.m'];
%   'd_009_dyn.m'];
PSAT_FILE = ['case_files' filesep 'd_014_dyn_mdl_pretty.m'];
% get current timestamp
TS = timestamp;
OUT_DIR = ['.data' filesep CASE_NAME '_' TS];
%%
[status, msg, msgID] = mkdir(OUT_DIR);
if ~status
   error('PSCD:base',msg);
end
%% Load matpower case
% MATPOWER file name    (opf data)

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
btFile = [OUT_DIR filesep CASE_NAME '_tightened' TS '.m'];

fprintf(pad(['Save BT model ' btFile ' '],50,'right','.'))
savecase(btFile, mpc)
fprintf('[ OK ]\n')
toc(t)

%% Bound tightening & Quadratic Convex relaxation of ACOPF
%   "Iteratively tighten bounds on voltage magnitude and phase-angle
%   difference variables."

% PSDC home folder \data\
hF = [pwd filesep OUT_DIR filesep];
% Separating planes of polytope
N_ITERATIONS = 1000;
% Number of uniform samples from the polytope
N_SAMPLES=1000;
% Output file name (containing the uniformly distributed samples
OUT_FILE_NAME_SAMPLES=[hF CASE_NAME '_QCRM_' num2str(N_ITERATIONS) '.csv'];
% System call to start julia
stat = system(['julia qc_relaxation.jl --bit 5 --bto 300 "'  btFile '" "'...
    num2str(N_ITERATIONS) '" "' OUT_FILE_NAME_SAMPLES '"  "'...
    num2str(N_SAMPLES) '"']);
if stat
    error('PSDC:julia','Something went wrong.')
end

% This can be run only locally!

% ------
% TODO:
% ssh to hpc
% create out dir in PSDC
% scp the _QCRM_ file
% submit job script to run ACOPF checks
% submit job to run DWs

