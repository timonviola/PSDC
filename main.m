clear
%                   ====== Load matpower case =====
caseName = 'case14';%'case118'; %996 sec for 10 iterations
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
'" "' outFileNameA '" "' outFileNameB '" "' outFileNameX '"']);
% 
% stat = system(['julia qc_relaxation.jl "' btFile '" "' num2str(numberOfIterations) ...
% '" "' outFileNameA '" "' outFileNameB '" "' outFileNameX '" -l debug']);

% ===== Load A,b matrices =====
A = readmatrix(outFileNameA);
b = readmatrix(outFileNameB);
xOpt = readtable(outFileNameX, 'ReadVariableNames',true);
xOpt = xOpt(:,sort(xOpt.Properties.VariableNames)); % sort columns

% ===== Uniform sampling of N2 points from Ax <= b =====
nSamples = 1e3;
N_3 = cprnd(nSamples,A,b); % it might be neccessary to create a mapping between the variables - rescale etc.
% fRed = 0.9;
% N_3 = N_3.*fRed;

% ===== directed walks =====
[l, nDim] = size(xOpt);
setpointClassification = nan(nSamples,1);   
classDetails = cell(n,1);
dampingRatio = nan(n,1);

parfor i = 1:nSamples
    [classification(iter,:),classDetails{iter},dampingRatio(iter)] = util.classifyCase(mpc,setpoints(iter,:),genList,mpOption);
end

