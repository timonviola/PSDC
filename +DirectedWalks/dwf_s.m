% Copyright (c) 2020 Timon Viola

% DWF_S Development implementation of brute force directed walk algorithm.
% DWF_S is a heavily modified version of the core algorithm that has
% multiple break hooks in case of a stuck descent.
%
% This script is used to develop/modify the core algorithm. It implements
% debugging, step-by-step plotting and saving the plots as GIF.
%
% For detailed mathematical description of the algorithm
% See also DIRECTEDWALKS.DWF

%   starting point
% ACOPF_SEED = '.data/case9_2020_06_03T162628Z/case9_ACOPF.csv';%'.data/case9_ACOPF.csv';
% CASE_FILE = 'case_files/case9.m';
% PSAT_FILE = 'case_files/d_case9.m';

% ACOPF_SEED = '.data/case14_2020_06_09T220252Z/case14_ACOPF.csv';%'.data/case9_ACOPF.csv';
% CASE_FILE = 'case_files/case14.m';
% PSAT_FILE = 'case_files\d_case14.m';

% ACOPF_SEED = '.data\case39_2020_06_16T103242Z\case39_ACOPF.csv';%'.data/case9_ACOPF.csv';
% CASE_FILE = 'case_files/case39.m';
% PSAT_FILE = 'case_files\d_case39.m';
% 
% ACOPF_SEED = '.data/case68_2020_06_23T120826Z/case68_ACOPF.csv';
ACOPF_SEED = '.data/case68_2020_06_23T161833Z/case68_ACOPF_mod.csv';
CASE_FILE = 'mod_case68.m';
PSAT_FILE = 'case_files/d_case68.m';

acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,util.natsort(acopfResults.Properties.VariableNames));
% setPoints = acopfResults{100,:};
setPoint = acopfResults{93,:}; %-> pingpoing at dist = 0.0055

% enable plotting
PRINT = true;
% wrtie gif from plot
GIF = false;
% enable pf printing
POT = {};
if PRINT
    POT = {'print'};
end


% CASE9 & CASE14
% ZETAMIN = 0.03;

% CASE39 & CASE68
% ZETAMIN = 0.0125;
ZETAMIN = 0.03;
% ----- start of function -----
% inputs
import DirectedWalks.*
t1 = tic;
% ------ DW hyper parameters ------
% min distance from DR (also in getStepSize func)
D_min = 0.0025;%zeta_crit*0.25 0.03*1.0909 && 0.03*(1 - 0.0909)
% max number of iterations
K_max = 1e2;
SmallestStepSizeScale = 0.0005;
E(1) = 0.3;
E(2) = 0.2;
E(3) = 0.2;
E(4) = 0.05;

D(1) = 0.07;
D(2) = 0.032;
D(3) = 0.0095;

% ------ PSAT/MATPOWER initialization ------
% MATPOWER INIT
MPC = loadcase(CASE_FILE);
% PMAX vector of generators
PMAX = 9; VMAX = 12;%PMIN = 10;
gIdx = util.getGenList(MPC);
allGIdx = MPC.gen(:,1);
% Vector of max PGs and voltages
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
nDim = size(setPoint,2);

% ------ DW initialization ------
% DW iterator
i = 1;
% shift register that tracks if dw is stuck
nBuff = 5;
buff = rand(1,nBuff);
% array of set points
NEW_DS_POINTS = [];%cell{K_max, nDim};
% get current zeta

% number of generators except slack
nPG = size(ps.PV.store,1);
% init DW variables

nSP = setPoint;
ps.PVSet(nSP);
ps.runpsat('pf')
ps.fm_abcd();


% ------ preliminary set point check ------
% This check is neccessary in case that the OPF constraints are stricter
% than SSS. OPF limit violations are checked, if it cannot be enforced with
% the given voltage limits the DW quits, this acopf seed is discarded.

% check if nSP is OPF feasible
res = ps.powerFlowResults(POT{:});
[opfStab, opfDet] = checkOPFLimits(MPC, res, POT{:});
if ~opfStab
    warning('PSCD:OPF:limitviolation',['OPF limits are violated.' ...
        'Retry with enforced Q-limits.\nPG QG VM Sf\n' num2str(opfDet)])
    nSP = util.nearestOptim(MPC,nSP);
    ps.PVSet(nSP);
    % enforce q limits
    ps.Settings.pv2pq = 1;
    ps.runpsat('pf')
    ps.fm_abcd();
    res = ps.powerFlowResults(POT{:});
    [opfStab, opfDet] = checkOPFLimits(MPC, res, POT{:});
    if ~opfStab
        warning('PSCD:OPF:limitviolation',['OPF limits are violated.' ...
            'Quitting directed walk.\nPG QG VM Sf\n' num2str(opfDet)])
        % quit DW
        return
    end
end
[~, curDR] = SmallSignalStability.checkSmallSignalStability(ZETAMIN, ps.LA.a);
DR = curDR;
dist = getDist(DR,'zetaMin',ZETAMIN);
buff(nBuff) = DR;

EXIT = false;
im = {};
if PRINT
    [fig, ax, prop] = plot.plotDWInit('zetaMin',ZETAMIN,'legend',true); % ax
    [etH, et] = plot.addTimeElapsedBox(fig);
    drLine = cell(K_max,1);
    drLine{i} = plot.plotDwUpdate(ax,0,DR,prop,nSP);
    feasProp = plot.greenProps();
    frame = getframe(fig);
    im{i} = frame2im(frame);
end
while i <= K_max
    while dist > D_min && i <= K_max
        alpha_k = getStepSize(dist, gMaxVec, 'epsLims',E,'dLims',D);
        % get the gradient
        [gradDir, im] = getStepDir(ps, nSP, DR,'zetaMin',ZETAMIN,'print',PRINT,'imwrite',im);
        
        % calculate new set point
        nSP = nSP + (alpha_k.* gradDir)';
        % take the step: set psat object to new set point values
        ps.PSet(nSP);
        ps.runpsat('pf');
        ps.fm_abcd();
        % get new DR
        [~, DR] = SmallSignalStability.checkSmallSignalStability(ZETAMIN, ps.LA.a);
        buff = circshift(buff,-1);
        buff(nBuff) = DR;
        dist = getDist(DR,'zetaMin',ZETAMIN);
        %         fprintf('nSP ')
        %         disp(nSP)
        
        if PRINT
            fprintf('DR  ')
            disp(DR)
            fprintf('dist')
            disp(dist)
            etH.String = ['Elapsed time: ' util.getTimeElapsed(et)];
            drLine{i} = plot.plotDwUpdate(ax,i,DR,prop,nSP);
            frame = getframe(gcf);
            imIdx = length(im)+1;
            im{imIdx} = frame2im(frame);
            
        end
        i = i+1;
        % IF WE end up pingpong ing between 2 points quit !
        if ~(any(diff(buff)))
            warning('PSDC:DW','Stuck at -1. exiting')
            EXIT = true;
            break
        end
        if numel(uniquetol(buff,1e-5)) <= 2 % 1e-3 tolerance too large c39
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
    [gradDir,im] = getStepDirPV(ps, nSP, DR, 'print',PRINT,'imwrite',im,'zetaMin',ZETAMIN);
    alpha_k = step_min;
    % calculate the new set point
    %     nSP(1:nPG) = nSP(1:nPG) + (alpha_k .* gradDir)';
    nSP = nSP + (alpha_k .* gradDir)';
    % take the step: set psat object to new set point values
    ps.PVSet(nSP);
    ps.runpsat('pf');
    ps.fm_abcd();
    % get new DR
    [~, DR] = SmallSignalStability.checkSmallSignalStability(ZETAMIN, ps.LA.a);
    dist = getDist(DR,'zetaMin',ZETAMIN);
    if PRINT
        etH.String = ['Elapsed time: ' util.getTimeElapsed(et)];
        drLine{i} = plot.plotDwUpdate(ax,i,DR,feasProp,nSP);
        frame = getframe(gcf);
        imIdx = length(im)+1;
        im{imIdx} = frame2im(frame);
        % fprintf('nSP ')
        % disp(nSP)
        % fprintf('DR ')
        % disp(DR)
        % fprintf('dist ')
        % disp(dist)
    end
    % get new dist??? as well? so if we diverge from boundary we take dw
    % again to go back close to boundary
    
    
    [LIDX, ~]=ismember(nSP, NEW_DS_POINTS,'rows');
    if LIDX
        warning('PSDC:DW','New setpoint already in data set. Exiting dw.')
        break
    end
    i = i+1;
end
toc(t1)
% % APPEND TO DATA_SET.CSV the NEW_DS_POINTS vector
% writematrix(NEW_DS_POINTS,'set_points_case9_1.csv');
%
% util.dataSummary
if PRINT && GIF
    filename = 'testAnimated.gif'; % Specify the output file name
    nImages = length(im);
    for idx = 1:nImages
        [A,map] = rgb2ind(im{idx},256);
        if idx == 1
            imwrite(A,map,filename,'gif','LoopCount',1,'DelayTime',0.1);
        else
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
        end
    end
end
















