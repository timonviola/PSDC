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

printOptions = {'print',''};
printDefault = {};
zetaMinDefault = 0.03;

p = inputParser;
addOptional(p,'zetaMin',zetaMinDefault , @(x)isnumeric(x))
addParameter(p,'print',printDefault, @(x) ismember(x,printOptions) || iscell(x))
parse(p,varargin{:})

zetaMin = p.Results.zetaMin;
PRINT = p.Results.print;
if ~iscell(PRINT)
    PRINT = {PRINT};
end
% ----- Initialize data -----
% matpower
loadedCase = loadcase(matpowerFName);
% psat
ps = psat('command_line_psat',true,'nosplash',true);
ps.clpsat.mesg = 0;
ps.clpsat.readfile = 0;
% enforce q-limits w/ bus type swing
% do not enforce per default
ps.Settings.pv2pq = 0;
ps.runpsat(psatFName,'data')
ps.runpsat('pf') 

%TODO: use ps.PVSet

% ----- Set P_g, V_g -----
PG = 4; VG = 5;
nPG = size(ps.PV.store,1);
% Set power-flow data 
%   PV (generator) buses - section 10.5
generatorData = ps.PV.store;
[~,sortIdx] = sort(generatorData(:,1));
% set PGs 
generatorData(sortIdx,PG) = setPoints(1:nPG);
slackData = ps.SW.store;
% set slack voltage!
slackData(4) = setPoints(nPG+1); 
% set gen voltages
generatorData(sortIdx,VG) = setPoints(nPG+2:end);
% re-assign modified values to psat obj
ps.SW.store = slackData;
ps.PV.store = generatorData;
% run modified pf
ps.runpsat('pf');
% power flow results, 'print' option available
res = ps.powerFlowResults(PRINT{:});

% ----- Optimal Power Flow criteria -----
[opfStab, opfDet] = DirectedWalks.checkOPFLimits(loadedCase,res,PRINT{:});

% TODO if failed set ps.Settings.pv2pq = 1; and retry.
if ~opfStab
    if any(strcmp(PRINT,'print'))
        warning('PSCD:OPF:limitviolation',['OPF limits are violated.' ...
        'Retry with enforced Q-limits.\nPG QG VM Sf\n' num2str(opfDet)])
    end    
    % try with enforced q-limits
    ps.Settings.pv2pq = 1;
    ps.SW.store = slackData;
    ps.PV.store = generatorData;
    ps.runpsat('pf');
    res = ps.powerFlowResults(PRINT{:});
    [opfStab, opfDet] = DirectedWalks.checkOPFLimits(loadedCase,res,PRINT{:});
end
% if ~opfStab
%     sssStab = nan;
%     minDR = nan;
%     if any(strcmp(options,'print'))
%         warning('PSCD:OPF:limitviolation',['OPF limits are violated.' ...
%         '\nPG QG VM Sf\n' num2str(opfDet)])
%     end  
% else
% ----- Small Signal Stability -----
ps.fm_abcd();
[sssStab, minDR] =...
    SmallSignalStability.checkSmallSignalStability(zetaMin,ps.LA.a);
% end
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








