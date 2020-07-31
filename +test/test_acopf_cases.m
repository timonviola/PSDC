% Test case that verifies OOPSAT vs MATPOWER results.

% Copyright (C) 2020 Timon Viola

%% Test 39 bus system
% The datafiles contain equivalent static (power flow) data.
c39 = 'case_files/case39.m';
MPC = loadcase(c39);
res = runpf(c39);
test.checklimits(res,1,0)
% MATPOWER - gen 2 limits PG constraints

% psat test
PSAT_FILE = 'case_files\d_case39.m'; %d_IEEE39bus.m';
% PSAT INIT
ps = psat('command_line_psat',true,'nosplash',true);
ps.clpsat.mesg = 0;
ps.clpsat.readfile = 0;
% enforce q-limits w/ bus type swing
% do not enforce per default
ps.runpsat(PSAT_FILE,'data')
ps.runpsat('pf')
ps.Settings.pv2pq = 1;
ps.runpsat('pf')
res_psat = ps.powerFlowResults('print');
[opfStab,opfDet] = DirectedWalks.checkOPFLimits(MPC, res_psat, 'print')%#ok
% OOPSAT - gen 2 limits PG constraints

% In both cases generator 2 violates the active power constraint of the OPF
% problem. In both cases the power flow results are the same (with a
% sufficiently small tolerance).
%% set psat to mpc results 

% In this scenario we find the closest ACOPF feasible point and set the
% results as input to the previous evaluation. The expected results are to
% see that both MATPOWER and OOPSAT returns a power flow solution that
% satisfies ACOPF constraints.

resOpf = runopf(c39);
resPf = runpf(resOpf);
test.checklimits(resPf, 1, 0)
% MATPOWER - no violations

% set only generator power:
% [GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, MU_PMAX,...
%     MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, QC2MIN, QC2MAX,...
%     RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;
PG = 2; VG = 6;
nSP = [resPf.gen(util.getGenList(MPC),PG)'./resPf.baseMVA resPf.gen(:,VG)'];
ps.PVSet(nSP);
ps.runpsat('pf')
res_psat = ps.powerFlowResults('print');
[opfStab,opfDet] = DirectedWalks.checkOPFLimits(MPC, res_psat, 'print')%#ok


ps.fm_abcd();
[~, curDR] = SmallSignalStability.checkSmallSignalStability(.03, ps.LA.a);

%% Test 68 bus system
c39 = 'case_files/case68.m';
MPC = loadcase(c39);
res = runpf(c39);
test.checklimits(res,1,0)
% MATPOWER - gen 2 limits PG constraints

% psat test
PSAT_FILE = 'case_files\d_case68.m';
% PSAT INIT
ps = psat('command_line_psat',true,'nosplash',true);
ps.clpsat.mesg = 0;
ps.clpsat.readfile = 0;
% enforce q-limits w/ bus type swing
% do not enforce per default
ps.runpsat(PSAT_FILE,'data')
ps.runpsat('pf')
ps.Settings.pv2pq = 1;
ps.runpsat('pf')
res_psat = ps.powerFlowResults('print');
[opfStab,opfDet] = DirectedWalks.checkOPFLimits(MPC, res_psat, 'print')%#ok
% OOPSAT - gen 2 limits PG constraints