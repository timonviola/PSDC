function NEW_DS_POINTS = dwf_f(setPoint, PSAT_FILE, CASE_FILE,varargin)
% DWF_F Directed walk function.
% See also DIRECTEDWALKS.DWF
PRINT = false;
if nargin > 3
    if strcmp(varargin{1},'print')
        PRINT = true;
    end
end
% MATPOWER INIT
MPC = loadcase(CASE_FILE);
% PMAX vector of generators
PMAX = 9; %PMIN = 10;
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


% min distance from DR (also in getStepSize func)
D_min = 0.0025;%zeta_crit*0.25 0.03*1.0909 && 0.03*(1 - 0.0909)
% max number of iterations
K_max = 1e2;
% minimum step size ( also in get step size func)
step_min = gMaxVec.*0.0005;

nDim = size(setPoint,2);

nBuff = 3;
buff = zeros(1,nBuff);
NEW_DS_POINTS = [];%cell{K_max, nDim};

% get current zeta
[~, curDR] = SmallSignalStability.checkSmallSignalStability(.03, ps.LA.a);

% number of generators except slack
nPG = size(ps.PV.store,1);

DR = curDR;
buff(nBuff) = DR;
nSP = setPoint;

ps.PVSet(nSP);
ps.runpsat('pf')
ps.fm_abcd();

dist = getDist(DR);

i = 1;
if PRINT
    DirectedWalks.plot_dw_init % ax
    drLine = cell(K_max,1);
    drLine{i} = DirectedWalks.plotDwUpdate(i,DR,prop,nSP);
end
while i <= K_max
    while dist > D_min && i <= K_max
        alpha_k = getStepSize(dist, gMaxVec);
        % get the gradient
        gradDir = getStepDir(ps, nSP, DR);
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
            drLine{i} = DirectedWalks.plotDwUpdate(i,DR,prop,nSP);
        end
        i = i+1;
        % IF WE end up pingpong ing between 2 points quit !
%         if (abs(buff(1)-buff(3)) < 1e-3)
%             warning('PSDC:DW','Stuck between 2 values, exiting')
%         end
    end
    % we are in HIC
    % take samples around the current point
    NEW_DS_POINTS = [NEW_DS_POINTS; nSP];                   %#ok FOR NOW DO NOT PREALLOCATE
    NEW_DS_POINTS = [NEW_DS_POINTS; getHICSamples(ps,nSP)]; %#ok FOR NOW DO NOT PREALLOCATE
    % take the next step with the minimum step size -> no step size calc
    % take the next step to the direction where the DR stays the same/close
    %     gradDir = getHICStepDir(ps, nSP, DR);
    gradDir = getStepDir(ps, nSP, DR);
    alpha_k = step_min;
    % calculate the new set point
    nSP(1:nPG) = nSP(1:nPG) + (alpha_k .* gradDir)';
    % take the step: set psat object to new set point values
    ps.PSet(nSP);
    ps.runpsat('pf');
    ps.fm_abcd();
    % get new DR
    [~, DR] = SmallSignalStability.checkSmallSignalStability(.03,ps.LA.a);
    dist = getDist(DR);
    % get new dist??? as well? so if we diverge from boundary we take dw
    % again to go back close to boundary
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

% % APPEND TO DATA_SET.CSV the NEW_DS_POINTS vector
% writematrix(NEW_DS_POINTS,'set_points_case9_1.csv');
% 
% util.dataSummary
end

% cost function
function dist = getDist(currentZeta)
% this should be a feasibility vector?
ZETA_MIN = 0.03;

dist = abs(ZETA_MIN - currentZeta);
end

function step = getStepSize(dist,PMAX)
% CONSTANTS
% step related constants
D_1 = 0.05;
D_2 = 0.01;
D_3 = 0.0025;%0.001; % D_min
% epsilons
% EXPERIMENTAL VALUES:
E_1 = 0.02;
E_2 = 0.01;
E_3 = 0.005;
E_4 = 0.0025;

% SAFE VALUES- BUT CONVERGES TOO SLOW ON MIN_DIST 0.0025
% E_1 = 0.01;
% E_2 = 0.005;
% E_3 = 0.001;
% E_4 = 0.0005;

step = 0;   %#ok
if dist > D_1
    step = PMAX.*E_1;
elseif D_1 >= dist && dist > D_2
    step = PMAX.*E_2;
elseif D_2 >= dist && dist > D_3
    step = PMAX.*E_3;
else
    step = PMAX.*E_4;
end
end

function grad = getStepDir(ps, setPoints, curDR)
% calculate SSS for 2*nPG direction of N-dimensional space
ZETA_MIN = 0.03;
% mu = 0.05; % small perturbation applied to G
if ~(getDist(curDR) < 0.006)
    mu = 0.05;
else
    mu = 0.0005;
end
PG = 4;
nPG = size(ps.PV.store,1);
drs = nan(2*nPG,1);
% drs = nan(nPG,1);
generatorData = ps.PV.store;
[~,sortIdx] = sort(generatorData(:,1));
for i = 1:nPG
    % set PGs
    ddSP = setPoints(1:nPG);
    ddSP(i) = ddSP(i) + mu;
    generatorData(sortIdx,PG) = ddSP;
    ps.PV.store = generatorData;
    ps.runpsat('pf');
    ps.fm_abcd();
    [~, drs(i)] = SmallSignalStability.checkSmallSignalStability(ZETA_MIN, ps.LA.a);
end
% % same but for - direction
for i = 1:nPG
    % set PGs
    ddSP = setPoints(1:nPG);
    ddSP(i) = ddSP(i) - mu;
    generatorData(sortIdx,PG) = ddSP;
    ps.PV.store = generatorData;
    ps.runpsat('pf');
    ps.fm_abcd();
    [~, drs(i+nPG)] = SmallSignalStability.checkSmallSignalStability(ZETA_MIN, ps.LA.a);
end
% we have a vector of all surrounding Zetas
% calculate the value & idx of direction that minimizes the distance
[~,idx] = min(abs(getDist(drs)));
% if sgnDir == 1 the dir = (+) else dir = (-)
sgnDir = (idx/nPG) <= 1;
if ~sgnDir
    sgnDir = -1;
end
genIdx = mod(idx,nPG);
if genIdx == 0
    genIdx = nPG;
end
% % ----- Fix movement along axis ------
% grad = zeros(1,nPG);
% grad(genIdx) = 1;
% % the gradient will look somehting like [0 0 0 0 -1 ... 0]
% % but this means we only step into one dim at a time...
% grad = sgnDir * grad';

% or with normalized gradient
% normalize
% % grad = (ZETA_MIN - drs)/norm(ZETA_MIN - drs);

% % ----- the real-real mathemtcal gradient -----
% %
% %      d f(a)   f(a+h) - f(a)
% % m = ------ = ---------------
% %       d a          h
%
% % grad = (drs - curDR)/mu;
% % from this we have (+)/(-) direction gradient the lowest should be taken?

% calculate norm gradient vector based on my shitty logic
desiredPoint = setPoints(1:nPG);
desiredPoint(genIdx) = desiredPoint(genIdx) + sgnDir*mu;
gradV = desiredPoint - setPoints(1:nPG);
grad = (gradV/(norm(gradV)))';
end

function samples = getHICSamples(ps, setPoints)
% get samples around setPoints
% as of now don't check anything just take the sample
% Radius around setPoints that the samples are gathered
R = 0.05;
% I AM MISSING THE DISCRETIZATION FACTOR! -> 0.01
% WHEN I REWRITE THIS PART -> DISCRETIZATION FACTOR INCLUDED SO ALL
% DISCRETE POINTS INSIDE RADIUS ARE ADDED TO THE DATASET!

nDim = size(setPoints,2); %#ok
dVec = 0.01:0.01:R; % 0+alpha : alpha : R
nNewSP = size(dVec,2);
% PG = 4;
nPG = size(ps.PV.store,1);
samples = [];% nan(nPG*nNewSP,nDim)

for i = 1:nPG
    tmpSP = repmat(setPoints,2*nNewSP,1);
    tmpSP(1:nNewSP,i) = setPoints(i) + dVec;
    tmpSP(nNewSP+1:end,i) = setPoints(i) - dVec;
    samples = [samples; tmpSP];         %#ok FOR NOW DO NOT PREALLOCATE
end
end




