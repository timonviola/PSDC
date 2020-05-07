clear
t = tic;
caseName = 'case14';    % MATPOWER file name    (opf data)
psatFileName = '';      % PSAT file name        (dynamic data)

fprintf(pad(['Load casefile ' caseName ' '],50,'right','.'))
mpc = loadcase(caseName);

fprintf('[ OK ]\n')
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

%% ===== Load A,b matrices =====
fprintf(pad('Load output files.',50,'right','.'))
A = readmatrix(outFileNameA);
b = readmatrix(outFileNameB);
xOpt = readtable(outFileNameX, 'ReadVariableNames',true);
xOpt = xOpt(:,sort(xOpt.Properties.VariableNames)); % sort columns
fprintf('[ OK ]\n')
%% ===== Uniform sampling of N2 points from Ax <= b =====
nSamples = 1e3;
N_3 = cprnd(nSamples,A,b); % it might be neccessary to create a mapping between the variables - rescale etc.
fRed = 0.9;
N_3 = N_3.*fRed;

%% ===== directed walks =====
[l, nDim] = size(xOpt);

%   Input data
% psatFileName    % PSAT
% reTightenedFile % MATPOWER

% boolean classification
setpointClassification = nan(nSamples,1);      
% criteria fail/pass details
classDetails = cell(n,1);                      
% damping ratios (stored separately for easier access)
dampingRatio = nan(n,1);

parfor i = 1:nSamples
    [setpointClassification(iter,:),classDetails{iter},dampingRatio(iter)] = ...
        DirectedWalks.checkSetpoint(setpoints(iter,:),psatFileName,reTightenedFile);
end


toc(t)
































