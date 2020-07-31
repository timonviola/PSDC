% Greedy directed walk function considering AC-OPF limits.

% Copyright (c) 2020 Timon Viola
function NEW_DS_POINTS = dwg_f2(setPoint, PSAT_FILE, CASE_FILE,varargin)
% greedy directed walk function with ACOPF constrained step direction
% choice.

zetaMinDefault = 0.03;
printDefault = false;
p = inputParser;
addRequired(p,'setPoint',@(x) isnumeric(x))
addRequired(p,'PSAT_FILE')
addRequired(p,'CASE_FILE')
addOptional(p,'zetaMin',zetaMinDefault , @(x)isnumeric(x))
addParameter(p,'print',printDefault, @(x)islogical(x))

parse(p,setPoint, PSAT_FILE, CASE_FILE, varargin{:})
setPoint = p.Results.setPoint;
PSAT_FILE = p.Results.PSAT_FILE;
CASE_FILE = p.Results.CASE_FILE;
zetaMin = p.Results.zetaMin;
PRINT = p.Results.print;


import DirectedWalks.*

% ------ DW hyper parameters ------
% min distance from DR
D_min = 0.0025;
% max number of iterations
K_max = 1e2;
SmallestStepSizeScale = 0.5;
% HICStepSizeScale = 0.005; % TODO: make sure that its consistents with alpha
HICStepSizeScale = 0.05; % case39 only

% ------ PSAT/MATPOWER initialization ------
% MATPOWER INIT
MPC = loadcase(CASE_FILE);
% PMAX vector of generators
PMAX = 9;VMAX = 12;
gIdx = util.getGenList(MPC);
allGIdx = MPC.gen(:,1);
gMaxVec = [MPC.gen(gIdx,PMAX)./MPC.baseMVA; MPC.bus(allGIdx,VMAX)];
% PSAT INIT
ps = psat('command_line_psat',true,'nosplash',true);
ps.clpsat.mesg = 0;
ps.clpsat.readfile = 0;
% enforce q-limits w/ bus type swing
% do not enforce per default
ps.Settings.pv2pq = 0;
ps.runpsat(PSAT_FILE,'data')
ps.runpsat('pf')
ps.fm_abcd();

% minimum step size ( also in get step size func)
step_min = gMaxVec.*SmallestStepSizeScale;

% ------ DW initialization ------
% DW iterator
i = 1;
% shift register that tracks if dw is stuck
nBuff = 5;
buff = zeros(1,nBuff);
NEW_DS_POINTS = [];%cell{K_max, nDim};

% get current zeta
[~, curDR] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);
% number of generators except slack
nPG = size(ps.PV.store,1);
DR = curDR;
dist = getDist(DR,zetaMin);
buff(nBuff) = DR;
nSP = setPoint;
ps.PVSet(nSP);
ps.runpsat('pf')
ps.fm_abcd();

% ------ preliminary set point check ------
% check if nSP is OPF feasible
res = ps.powerFlowResults;
[opfStab, opfDet] = DirectedWalks.checkOPFLimits(MPC, res);
if ~opfStab
    warning('PSCD:OPF:limitviolation',['OPF limits are violated.' ...
        'Retry with enforced Q-limits.\nPG QG VM Sf\n' num2str(opfDet)])
    nSP = util.nearestOptim(MPC,nSP);
    ps.PVSet(nSP);
    % enforce q limits
    ps.Settings.pv2pq = 1;
    ps.runpsat('pf')
    ps.fm_abcd();
    res = ps.powerFlowResults;
    [opfStab, opfDet] = DirectedWalks.checkOPFLimits(MPC, res);
    if ~opfStab
        warning('PSCD:OPF:limitviolation',['OPF limits are violated.' ...
            'Quitting directed walk.\nPG QG VM Sf\n' num2str(opfDet)])
        % quit DW
        return
    end
end

EXIT = false;
if PRINT
    [fig, ax, prop] = plot.plotDWInit('zetaMin',zetaMin,'legend',true); % ax
    [etH, et] = plot.addTimeElapsedBox(fig);
    drLine = cell(K_max,1);
    drLine{i} = plot.plotDwUpdate(ax,0,DR,prop,nSP);
    feasProp = plot.greenProps();
end
while i <= K_max
    while dist > D_min && i <= K_max
        alpha_k = step_min;
        % get the gradient
        gradDir = getGreedyLims(ps, nSP, DR, MPC, alpha_k,'zetaMin',zetaMin,'print',PRINT);
        % calculate new set point
        nSP = nSP + (alpha_k .* gradDir)';
        % take the step: set psat object to new set point values
        ps.PVSet(nSP);
        ps.runpsat('pf');
        ps.fm_abcd();
        % get new DR
        [~, DR] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);
        buff = circshift(buff,-1);
        buff(nBuff) = DR;
        dist = getDist(DR,zetaMin);
        
        if PRINT
            etH.String = ['Elapsed time: ' util.getTimeElapsed(et)];
            drLine{i} = plot.plotDwUpdate(ax,i,DR,prop,nSP);
        %         fprintf('nSP ')
        %         disp(nSP)
        %         fprintf('DR ')
        %         disp(DR)
        %         fprintf('dist ')
        %         disp(dist)
        end
        i = i+1;
        if ~(any(diff(buff)))
            warning('PSDC:DW','Stuck at -1. exiting')
            EXIT = true;
            break
        end
        if numel(uniquetol(buff,1e-3)) <= 2
            warning('PSDC:DW','Stuck between 2 values, exiting')
            EXIT = true;
            break
        end
    end
    if i > K_max
        break
    end
    if EXIT
        break
    end
    % we are in HIC
    % take samples around the current point
    NEW_DS_POINTS = [NEW_DS_POINTS; nSP];                   %#ok FOR NOW DO NOT PREALLOCATE
    NEW_DS_POINTS = [NEW_DS_POINTS; getHICSamples(nSP,MPC)]; %#ok FOR NOW DO NOT PREALLOCATE
    % take the next step with the minimum step size -> no step size calc
    % take the next step to the direction where the DR stays the same/close
    %     gradDir = getHICStepDir(ps, nSP, DR);
    gradDir = getGreedyLims(ps, nSP, DR, MPC, alpha_k,'zetaMin',zetaMin,'print',PRINT);
    alpha_k = gMaxVec.*HICStepSizeScale;
    % calculate the new set point
    nSP = nSP + (alpha_k .* gradDir)';
    % take the step: set psat object to new set point values
    ps.PVSet(nSP);
    ps.runpsat('pf');
    ps.fm_abcd();
    % get new DR
    [~, DR] = SmallSignalStability.checkSmallSignalStability(zetaMin,ps.LA.a);
    dist = getDist(DR,zetaMin);
    if PRINT
        etH.String = ['Elapsed time: ' util.getTimeElapsed(et)];
        drLine{i} = plot.plotDwUpdate(ax,i,DR,feasProp,nSP);
    %     fprintf('nSP ')
    %     disp(nSP)
    %     fprintf('DR ')
    %     disp(DR)
    %     fprintf('dist ')
    %     disp(dist)
    end
   
    
    [LIDX, ~]=ismember(nSP, NEW_DS_POINTS,'rows');
    if LIDX
        warning('PSDC:DW','New setpoint already in data set. Exiting dw.')
        break
    end
    i = i+1;
end

NEW_DS_POINTS = uniquetol(NEW_DS_POINTS,HICStepSizeScale,'ByRows',true);
end


