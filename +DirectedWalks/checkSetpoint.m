%CHECKSETPOINT Check setpoint feasibility.
%   class = CHECKSETPOINT(setPoints, psatFName, matpowerFName) returns the
%   the binary classification of the set point.The set point is defined by
%   the vector of [P_g, V_g] values. The system is defined by the dynamic
%   data file (psatFName) and the static data file (matpowerFName).
%
%   [class, details, dampingRatio] = CHECKSETPOINT(setPoints,
%   psatFName,matpowerFName) returns classification details where details
%   is a binary classification vector and has the following elements:
%     o Pg generator real power
%     o Qg generator reactive power
%     o Vbus bus voltage magnitude
%     o S branch flows
%     o Small-signal stability
%   in each case 1 means no violation and 0 means the criteria was
%   violated.
%   dampingRatio is the smallest undamped natural frequency of the power 
%   system. Small signal stability depends on wether this value is larger
%   equal to zetaMin.
%
%   [__] = CHECKSETPOINT(__,Name,Value) uses additional options specified
%   by one or more Name-Value pair arguments. Possible name-value pairs:
%      zetaMin - Redefine the critical damping ratio. Default = 0.03.
%      print   - Output power-flow and criteria check results to the
%                command windows.
%
%   Example
%      import DirectedWalks.checkSetpoint
%      mF = 'case_files/case14.m';
%      pF = 'case_files/d_case14.m';
%      setP = [ 0.52  0.12  0.29  0.8  0.97  0.96  0.99  0.94  0.94];
%      [stab, class_det, dr] = CHECKSETPOINT(setP,pF,mF,...
%                              'zetaMin',0.025,'print',{'print'})
%
%   See also PSAT.PVSET, SMALLSIGNALSTABILITY.CHECKSMALLSIGNALSTABILITY,
%   DIRECTEDWALKS.CHECKOPFLIMITS.

% Copyright (C) 2020 Timon Viola
function varargout = checkSetpoint(setPoints,...
     psatFName,matpowerFName,varargin)
% PSAT is initialized inside the function to support parallel excecution.

printOptions = {'print',''};
printDefault = {};
zetaMinDefault = 0.03;

p = inputParser;
addRequired(p,'setPoints',@(x) isnumeric(x))
addRequired(p,'psatFName')
addRequired(p,'matpowerFName')
addOptional(p,'zetaMin',zetaMinDefault , @(x)isnumeric(x))
addParameter(p,'print',printDefault, @(x) ismember(x,printOptions) || iscell(x))
parse(p,setPoints,psatFName,matpowerFName,varargin{:})

setPoints = p.Results.setPoints;
psatFName = p.Results.psatFName;
matpowerFName = p.Results.matpowerFName;
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


ps.PVSet(setPoints);
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








