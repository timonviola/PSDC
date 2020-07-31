% Copyright (c) 2020 Timon Viola

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