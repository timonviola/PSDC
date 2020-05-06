clear
%                   ====== Load matpower case =====
caseName = 'case14';
mpc = loadcase(caseName);

%                   ====== Run bound tightening =====
options.bounds = 1; % tighten both voltage and angle differences
warning off
[mpc, info] = tighten_bounds(mpc, options);
warning on
btFile = ['.data\' caseName '_tightened.m'];         % with EXTENSION
savecase(btFile, mpc)

% ====== Quadratic Convex relaxation of ACOPF with bound tightening =====
numberOfIterations = 1000;
tmpF = [pwd '\.data\'];
outFileNameA = [tmpF caseName '_results_' timestamp 'A.csv'];
outFileNameB = [tmpF caseName '_results_' timestamp 'b.csv'];
outFileNameX = [tmpF caseName '_results_' timestamp 'Xopt.csv'];

stat = system(['julia qc_relaxation.jl "' btFile '" "' num2str(numberOfIterations) ... 
'" "' outFileNameA '" "' outFileNameB '" "' outFileNameX '"']); % optional -d flag to set log level

% ===== Load A,b matrices =====
A = readmatrix(outFileNameA);
b = readmatrix(outFileNameB);
x_opt = readtable(outFileNameX, 'ReadVariableNames',true);
x_opt = x_opt(:,sort(x_opt.Properties.VariableNames)); % sort columns

% ===== Uniform sampling of N2 points from Ax <= b =====


% ===== directed walks =====



