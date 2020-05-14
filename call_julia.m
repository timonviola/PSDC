clear
t = tic;
%% Load matpower case
caseName = 'case14';    % MATPOWER file name    (opf data)
psatFileName = '';      % PSAT file name        (dynamic data)

fprintf(pad(['Load casefile ' caseName ' '],50,'right','.'))
mpc = loadcase(caseName);

fprintf('[ OK ]\n')
%% Run bound tightening
% Bound tightening algorightm 
%   Reference: https://github.com/dmitry-shchetinin/BTOPF
options.bounds = 1; % tighten both voltage and angle differences
% options.opt_prob_flow=2;% use constraint in LP for BT based on flow envelopes
% options.opt_prob_inj=3;% use LP+SOCP for BT based on injection envelopes

fprintf(pad('Run BT ',50,'right','.'))
warning off
[mpc, info] = tighten_bounds(mpc, options);
warning on
fprintf('[ OK ]\n')

btFile = ['.data\' caseName '_tightened.m'];         % with EXTENSION
reTightenedFile = ['.data\' caseName '_tightened2.m'];
%btFile = ['case_files\' 'case14.m'];

fprintf(pad(['Save BT model ' btFile ' '],50,'right','.'))
savecase(btFile, mpc)
fprintf('[ OK ]\n')
%% Quadratic Convex relaxation of ACOPF with bound tightening
% Quadratic Convex relaxation of ACOPF with bound tightening:
%   "Iteratively tighten bounds on voltage magnitude and phase-angle
%   difference variables."
% res = qc_relax(mpc);
tmpF = [pwd '\.data\'];
outFileNameA = [tmpF caseName '_results_' timestamp 'A.csv'];
outFileNameB = [tmpF caseName '_results_' timestamp 'b.csv'];
outFileNameX = [tmpF caseName '_results_' timestamp 'Xopt.csv'];

numberOfIterations=1000;
fprintf(pad('Run BT + QC-ACOPF ',50,'right','.'))
stat = system(['julia qc_relaxation.jl "' btFile '" "' reTightenedFile '" "' ...
    num2str(numberOfIterations) '" "' outFileNameA '" "' outFileNameB '" "'...
    outFileNameX '"']);
fprintf('[ OK ]\n')


toc(t)
% fprintf(pad(['Load output file ' outFileName],50,'right','.'))
% % read julia output file
% mpc_new = loadcase(outFileName);
% fprintf('[ OK ]\n')
% %powerModelsResult = jsondecode(fileread(outFileName));

%% Load A,b matrices
fprintf(pad('Load output files.',50,'right','.'))
A = readmatrix(outFileNameA);% unscaled polytope data; 1:18 has to be discarded.
b = readmatrix(outFileNameB);% unscaled polytope data; 1:18 has to be discarded.

% xOpt are the qc relaxation points - these points are most likely outside
% of the ACOPF.
% xOpt = readtable(outFileNameX, 'ReadVariableNames',true);
% xOpt = xOpt(:,sort(xOpt.Properties.VariableNames)); % sort columns

fprintf('[ OK ]\n')
%% ===== Uniform sampling of N2 points from Ax <= b =====
nSamples = 1e3;
N_2 = cprnd(nSamples,A,b); % it might be neccessary to create a mapping between the variables - rescale etc.

%% ===== directed walks =====
[n, nDim] = size(A);

%   Input data
% psatFileName    % PSAT
% reTightenedFile % MATPOWER

% boolean classification
setpointClassification = nan(nSamples,1);      
% criteria fail/pass details
classDetails = cell(n,1);                      
% damping ratios (stored separately for easier access)
dampingRatio = nan(n,1);

% setpoints has to be checked if the values are passed in the right order
% e.g. the order might be non-ordered [2,6,3,8]

% TODO: use the original case
% % reTightenedFile = ".data\case14_tightened"; % loadcase() handles the rest
psatFileName = 'case_files\d_014_dyn_mdl_pretty.m';


% Setopint definition:
%
% As PowerModels and PSAT both stores data in unordered fashion an internal
% sorting is performed thus the PG and VG setpoint data can be passed as
% simple vectors.
% The internal sorting will assign the right values to each generator eg.:
%   define setpoints as [.3 .4 .2. .4, 1.1 1.01 1.02 .98]
%                       [    PG      ,        VG        ]
% DIRECTEDWALKS.CHECKSETPOINT will sort the psat generators and assign the
% right values e.g: first generator wll be PG = .3, VG = 1.1
%                   second gen      	   PG = .4, VG = 1.01 etc.
%
sp = [.8 .3 .8 .41 1.01 0.985 1.01 0.985];
% parfor i = 1:nSamples
[stable, criteriaPass, minDampingRation] = DirectedWalks.checkSetpoint(sp,psatFileName,reTightenedFile,'print')    
% [setpointClassification(iter,:),classDetails{iter},dampingRatio(iter)] = ...
%         DirectedWalks.checkSetpoint(setpoints(iter,:),psatFileName,reTightenedFile);
% end


toc(t)
































