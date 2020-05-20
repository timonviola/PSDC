%CHECKSETPOINT Check setpoint feasibility.
%   Check if setpoint passes the given criteria (e.g.:opf limits, SSS).
%
%   class = CHECKSETPOINT(setPoints, psatFName, matpowerFName) the
%   setpoint is defined by the vector of [P_g, V_g], the system dynamic data
%   is given by psatFName and the sytem OPF data is given by matpowerFName)
%
%   [class, details, dampingRatio] = CHECKSETPOINT(setPoints,
%   psatFName,matpowerFName) 
%
%   setPoints - the values that define the setpoint in the load-flow (Pg,Vg)
%   psatFName - the dynamic data file name
%   matpowerFName - the OPF data name, the variable bounds are extracted 
%   from this file.
%
%   Input arguments:
%     o setPoints! [scalar,numeric] Generator P_g and V_g that uniquly
%     specifies a setpoint of the system.
%     o psatFName! [file=*.m]
%
%   See also SMALLSIGNALSTABILITY.CHECKSMALLSIGNALSTABILITY,
%   DIRECTEDWALKS.CHECKOPFLIMITS.
function varargout = checkSetpoint(setPoints,...
     psatFName,matpowerFName,varargin)
% PSAT is initialized inside the function to support parallel excecution.

options = {};
if nargin > 3
    options = varargin;
end

% ----- Initialize data -----
% matpower
loadedCase = loadcase(matpowerFName);
% psat
ps = psat('command_line_psat',true,'nosplash',true);
ps.clpsat.mesg = 0;
ps.clpsat.readfile = 0;
% enforce q-limits w/ bus type swing
ps.Settings.pv2pq = 1;
ps.runpsat(psatFName,'data')
ps.runpsat('pf') 

% ----- Set P_g, V_g -----
PG = 4; VG = 5;
nPG = size(ps.PV.store,1);
% Set power-flow data 
%   PV (generator) buses - section 10.5
generatorData = ps.PV.store;
[~,sortIdx] = sort(generatorData(:,1));
generatorData(sortIdx,PG) = setPoints(1:nPG);
slackData = ps.SW.store;
slackData(4) = setPoints(nPG+1);
generatorData(sortIdx,VG) = setPoints(nPG+2:end);
% re-assign modified values to psat obj
ps.SW.store = slackData;
ps.PV.store = generatorData;
% run modified pf
ps.runpsat('pf');
% power flow results, 'print' option available
res = ps.powerFlowResults(options{:});

% ----- Optimal Power Flow criteria -----
[opfStab, opfDet] = DirectedWalks.checkOPFLimits(loadedCase,res,options{:});

% ----- Small Signal Stability -----
ps.fm_abcd();
[sssStab, minDR] =...
    SmallSignalStability.checkSmallSignalStability(.03,ps.LA.a);

% ----- output -----
if nargout >= 1
    class = opfStab && sssStab;
    varargout{1} = class;
end
if nargout >= 2
	details = [opfDet, sssStab];
	% return the boolean vector of criteria check results
    varargout{2} = details;
end
if nargout >= 3
    % return the smallest damping ratio
    varargout{3} = minDR;
end
% % currently unsupported
% if nargout >= 4
%     varargout{4} = ps;
% end
end








