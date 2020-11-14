%CHECKOPFLIMITSMTPW Check OPF limits using MATPOWER.
%   CHECKOPFLIMITSMTPW(matpowerCaseStruct, powerFlowResults) checks if pf 
%   results are within matpowerCase limits.
%   Check 4 most critical contingencies:
%     o Pg generator real power
%     o Qg generator reactive power
%     o Vbus bus voltage magnitude
%     o S branch flows
%
%  CHECKOPFLIMITS(__,'print') print min,max limits and values to STDOUT
%
%   Input arguments:
%     o case [string,file=*.m] matpower case file that contains limits data
%     o powerFlowResults [psat] psat object with solved pf data
%
%   Example
% 
%   See also SMALLSIGNALSTABILITY.CHECKSMALLSIGNALSTABILITY.

% Copyright (C) 2020 Timon Viola
function varargout = checkOPFLimitsMTPW(matpowerCase, setpoint, varargin)
% Inspired by MATPOWER CHECKLIMITS utility function:
% https://matpower.org/docs/ref/matpower7.0/extras/misc/checklimits.html
PRINT = false;
if nargin > 2
  mode = varargin{1};
  switch mode
    case 'print'
      PRINT = true;
    otherwise
      warning('OOPSAT:varargin:unknownOption', 'Unknown input option.')
  end
end


genList = util.getGenList(matpowerCase);
NG = sum(genList);
PG = 2; VG = 6; VMAX = 12; VMIN = 13; PMAX = 9; PMIN = 10; QMAX = 4;
QMIN = 5; RATE_A = 6; RATE_B = 7; RATE_C = 8; VM = 8; PF = 14; PT = 16; 
QF = 15; QT = 17; QG = 3;

mpopt = mpoption;
mpopt.out.all = 0;
mpopt.verbose = 0;
mpopt.pf.enforce_q_lims = 1;

success = zeros(1,4);
TOL = 0.1;
TOL_V = 0.001;

try
    matpowerCase.gen(genList,PG) = setpoint(1:(NG)).*matpowerCase.baseMVA;
    matpowerCase.gen(:,VG) = setpoint(NG+1:end);

    powerFlowResults = runpf(matpowerCase,mpopt);

    %% -----  generator real power  -----
    pChecks = ( matpowerCase.gen(:,PMIN)-TOL <= ...
            powerFlowResults.gen(:,PG)) & (powerFlowResults.gen(:,PG) <= ...
            matpowerCase.gen(:,PMAX)+TOL);

    success(1) = ~any(0 == pChecks);
    % -----  generator reactive power  -----
    qChecks = ( matpowerCase.gen(:,QMIN)-TOL <= ...
        powerFlowResults.gen(:,QG)) & (powerFlowResults.gen(:,QG) <= ...
        matpowerCase.gen(:,QMAX)+TOL);

    success(2) = ~any(0 == qChecks);
    % ----- bus voltage magnitude  -----
    vmChecks = (matpowerCase.bus(:,VMIN)-TOL_V <= ...
        powerFlowResults.bus(:,VM)) & (powerFlowResults.bus(:,VM)<= ...
        matpowerCase.bus(:,VMAX)+TOL_V);

    success(3) = ~any(0 == vmChecks);
    % -----  branch flows  -----
    Ff = (powerFlowResults.branch(:,PF).^2+powerFlowResults.branch(:,QF).^2).^(0.5);
    Ft = (powerFlowResults.branch(:,PT).^2+powerFlowResults.branch(:,QT).^2).^(0.5);
    F = max(Ff, Ft);
    % find branch flow violations
    Fv = zeros(3,1);
    Fv(1,1) = any(find(F > matpowerCase.branch(:, RATE_A) + ...
        TOL & matpowerCase.branch(:, RATE_A) > 0));
    Fv(2,1) = any(find(F > matpowerCase.branch(:, RATE_B) + ...
        TOL & matpowerCase.branch(:, RATE_B) > 0));
    Fv(3,1) = any(find(F > matpowerCase.branch(:, RATE_C) + ...
        TOL & matpowerCase.branch(:, RATE_C) > 0));

    success(4) = sum(Fv) < 1;
catch
    warning('PSDC:mpwr','Something went wrong.')
end

%% ----- print -----
% TODO: highight the line/column of the value violation using error() or
% '<strong></strong>'. success and qChecks etc. contains all information.
% if PRINT
%     % gen data
%     NG = size(powerFlowResults.gen.PG,1);
%     header = {' Bus','GEN PG','GEN QG'};
%     subheader = {'#','min','val','max',' ','min','val','max'};
%     sFormat = ['%3s', repmat('%8s',1,size(subheader,2)-1) '\n'];
%     util.printHeader('%3s%18s%32s\n',header,'\n\n<strong>%s</strong>\n','OPF LIMITS');
%     util.printHeader(sFormat,subheader)
%     tFormat = ' %2d%9.3f%9.3f%9.3f\t\t%9.3f%9.3f%9.3f\n';
%     tData = [powerFlowResults.gen.idx,...
%           matpowerCase.gen(:,PMIN)-TOL,powerFlowResults.gen.PG(:),...
%           matpowerCase.gen(:,PMAX)+TOL,matpowerCase.gen(:,QMIN)-TOL,...
%           powerFlowResults.gen.QG(:),matpowerCase.gen(:,QMAX)+TOL];
%     util.printTableContent(NG,tFormat,tData);
%     % bus data
%     NB = size(powerFlowResults.VM,1);
%     subheader = {'#','min','val','max'};
%     sFormat = ['%3s',repmat('%8s',1,size(subheader,2)-1) '\n'];
%     tFormat = [' %2d',repmat('%9.3f',1,3) '\n'];
%     tData = [(1:NB)',matpowerCase.bus(:,VMIN)-TOL,...
%         powerFlowResults.VM,matpowerCase.bus(:,VMAX)+TOL];
%     util.printHeader('\n %3s%18s\n',{'Bus','BUS VM'});
%     util.printHeader(sFormat,subheader)
%     util.printTableContent(NB,tFormat,tData)
%     % branch data
%     % RATE A    RATE B      RATE C --> TODO
% end
%% ----- output -----

SUCCESS = ~any( 0 == success(1:4));
switch nargout
    case 0
        % do nothing
    case 1
        varargout{1} = SUCCESS;
    case 2
        varargout{1} = SUCCESS;
        varargout{2} = success;
    case 3
        varargout{1} = SUCCESS;
        varargout{2} = success;
        varargout{3} = damping_ratio;
    otherwise
    error('Too many output arguments')
end