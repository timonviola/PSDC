clear
t = tic;
caseName = 'case14';
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
stat = system(['julia qc_relaxation.jl "' btFile '" "' num2str(numberOfIterations) ... 
'" "' outFileNameA '" "' outFileNameB '" "' outFileNameX '"']);
fprintf('[ OK ]\n')


% fprintf(pad(['Load output file ' outFileName],50,'right','.'))
% % read julia output file
% mpc_new = loadcase(outFileName);
% fprintf('[ OK ]\n')
% %powerModelsResult = jsondecode(fileread(outFileName));
toc(t)