function NEW_DS_POINTS = dwg_f(setPoint, PSAT_FILE, CASE_FILE,varargin)

PRINT = false;
if nargin > 3
    if strcmp(varargin{1},'print')
        PRINT = true;
    end
end
import DirectedWalks.*

% ------ DW hyper parameters ------
% min distance from DR
D_min = 0.0025;
% max number of iterations
K_max = 1e2;
SmallestStepSizeScale = 0.05;
HICStepSizeScale = 0.005; % TODO: make sure that its consistents with alpha


% ------ PSAT/MATPOWER initialization ------
% MATPOWER INIT
MPC = loadcase(CASE_FILE);
% PMAX vector of generators
PMAX = 9;
gIdx = util.getGenList(MPC);
gMaxVec = MPC.gen(gIdx,PMAX)./MPC.baseMVA; % TODO: remove slack
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
[~, curDR] = SmallSignalStability.checkSmallSignalStability(.03, ps.LA.a);
% number of generators except slack
nPG = size(ps.PV.store,1);
DR = curDR;
dist = getDist(DR);
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
    [fig, ax, prop] = plot.plotDWInit('legend',true); % ax
    [etH, et] = plot.addTimeElapsedBox(fig);
    drLine = cell(K_max,1);
    drLine{i} = plot.plotDwUpdate(ax,0,DR,prop,nSP);
    feasProp = plot.greenProps();
end
while i <= K_max
    while dist > D_min && i <= K_max
        alpha_k = step_min;
        % get the gradient
        gradDir = getGreedy(ps, nSP, DR,'print',PRINT);
        % calculate new set point
        nSP(1:nPG) = nSP(1:nPG) + (alpha_k .* gradDir)';
        % take the step: set psat object to new set point values
        ps.PSet(nSP);
        ps.runpsat('pf');
        ps.fm_abcd();
        % get new DR
        [~, DR] = SmallSignalStability.checkSmallSignalStability(.03, ps.LA.a);
        buff = circshift(buff,-1);
        buff(nBuff) = DR;
        dist = getDist(DR);
        %         fprintf('nSP ')
        %         disp(nSP)
        %         fprintf('DR ')
        %         disp(DR)
        %         fprintf('dist ')
        %         disp(dist)
        if PRINT
            etH.String = ['Elapsed time: ' util.getTimeElapsed(et)];
            drLine{i} = plot.plotDwUpdate(ax,i,DR,prop,nSP);
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
    NEW_DS_POINTS = [NEW_DS_POINTS; getHICSamples(nPG,nSP,MPC)]; %#ok FOR NOW DO NOT PREALLOCATE
    % take the next step with the minimum step size -> no step size calc
    % take the next step to the direction where the DR stays the same/close
    %     gradDir = getHICStepDir(ps, nSP, DR);
    gradDir = getStepDir(ps, nSP, DR, 'print',PRINT);
    alpha_k = gMaxVec.*HICStepSizeScale;
    % calculate the new set point
    nSP(1:nPG) = nSP(1:nPG) + (alpha_k .* gradDir)';
    % take the step: set psat object to new set point values
    ps.PSet(nSP);
    ps.runpsat('pf');
    ps.fm_abcd();
    % get new DR
    [~, DR] = SmallSignalStability.checkSmallSignalStability(.03,ps.LA.a);
    dist = getDist(DR);
    if PRINT
        etH.String = ['Elapsed time: ' util.getTimeElapsed(et)];
        drLine{i} = plot.plotDwUpdate(ax,i,DR,feasProp,nSP);
    end
    %     fprintf('nSP ')
    %     disp(nSP)
    %     fprintf('DR ')
    %     disp(DR)
    %     fprintf('dist ')
    %     disp(dist)
    
    [LIDX, ~]=ismember(nSP(1:nPG), NEW_DS_POINTS(:,1:nPG),'rows');
    if LIDX
        warning('PSDC:DW','New setpoint already in data set. Exiting dw.')
        break
    end
    i = i+1;
end


end


