function [feasible, classDetails, dampingRatio] = checkSetpoint(setPoints,psatFName,matpowerFName)
% setPoints - the values that define the setpoint in the load-flow (Pg,Vg)
% psatFName - the dynamic data file name
% matpowerFName - the OPF data name, the variable bounds are extracted from
%   this file

% 0 - set values (Pg,Vg)
% ------------
% 1 - run power flow
% 2 - check opf limits
% 3 - check damping ratio (SSS)


% TODO: initialize psat
% TODO: set generator active power Pg and bus voltages Vg to input vector
% TODO: execute power flow
% TODO: check setpoint

%% Initialize PSAT
ps = psat('command_line_psat',true,'nosplash',true);
ps.clpsat.mesg = 0;
ps.clpsat.readfile = 0;
ps.runpsat(psatFName,'data') % psatFName has to be full path e.g.:
% 'C:\Users\Timon\OneDrive - Danmarks Tekniske Universitet\Denmark\DTU\2019_20_II\software\case_files\d_009_dyn.m'

end