% Return closest ACOPF feasible setpoints to input set_points

function optimalSetpoint = nearestOptim(mpc,setPoint)

% TOL = 1;
% I don't want to pass the psat object just to get NG ...
NG = floor(length(setPoint)/2);

[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen; %#ok

% genList = util.getGenList(mpc);
% acopf full generation - acopf demand = acopff losses


% TODO: make sure that the right values are assigned to the right gen's
% Set generator values --> I SHOULD NOT SET THESE -> SO WE GET THE CLOSES
% POINT
% mpc.gen(genList, PMIN) = setPoint(1:NG)' -TOL;
% mpc.gen(genList, PMAX) = setPoint(1:NG)' +TOL;

% Configure mpc options
mpcOpt = mpoption;
mpcOpt.verbose = 0;
mpcOpt.out.all = 0;
mpcOpt.pf.enforce_q_lims = 0;
% Man: Used to determine voltage setpoint for optimal power flow only if 
% opf.use_vg option is non-zero (0 by default). Otherwise generator voltage
% range is determined by limits set for corresponding bus in bus matrix.
mpcOpt.opf.use_vg = 1;
% Set bus voltages
% TODO: make sure that generators are in the right order!!!!
mpc.gen(:, VG) = setPoint(NG+1:end)'; % TODO: check if VG is really the same
% run opf
[results,~] = runopf(mpc,mpcOpt);
if ~results.success
    warning('PSDC:UTIL','Could not enforce voltage set-points.')
    mpcOpt.opf.use_vg = 0;
    [results,~] = runopf(mpc,mpcOpt);
    if ~results.success
        warning('PSDC:UTIL','Could not find OPF solution.')
    end
end

% debug
%results.gen(:,[1,PG,VG])
% OOPSAT works with p.u. -> divide w/ baseMVA PG
optimalSetpoint = [results.gen(util.getGenList(mpc),PG)'./mpc.baseMVA results.gen(:,VG)'];

% This function returns the correct values if and only if the generators
% are ordered in ascending bus number in the MPC file.


% TODO: check if PSAT also thinks its acopf cool