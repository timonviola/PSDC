function [grad,varargout] = getStepDir(ps, setPoints, curDR, varargin)
% GETSTEPDIR Return the gradient of the new step.
% calculate SSS for 2*nPG direction of N-dimensional space
%
% See also DIRECTEDWALKS.DWF
import DirectedWalks.getDist

zetaMinDefault = 0.03;
printDefault = false;
imDefault = {};
p = inputParser;
addRequired(p,'ps')
addRequired(p,'setPoints')
addRequired(p,'curDR')
addOptional(p,'zetaMin',zetaMinDefault , @(x)isnumeric(x))
addParameter(p,'print',printDefault, @(x)islogical(x))
addParameter(p,'imwrite',imDefault)
parse(p,ps,setPoints,curDR,varargin{:})

ps = p.Results.ps;
setPoints = p.Results.setPoints;
curDR = p.Results.curDR;
zetaMin = p.Results.zetaMin;
PRINT = p.Results.print;
im = p.Results.imwrite;

% mu = 0.05; % small perturbation applied to G
% if ~(getDist(curDR) < 0.006)
%     mu = 0.05;
% else
    mu = 1;
% end
PG = 4;
nPG = size(ps.PV.store,1);
drs = nan(2*nPG,1);
% drs = nan(nPG,1);
generatorData = ps.PV.store;
[~,sortIdx] = sort(generatorData(:,1));

if PRINT
    ax = gca;
    plotIdx = max([ax.Children(1:end-3).YData]);
    pr = DirectedWalks.plot.probeProps;
    probePlots = cell(2*nPG,1);
end

for i = 1:nPG
    % set PGs
    ddSP = setPoints(1:nPG);
    ddSP(i) = ddSP(i) + mu;
    generatorData(sortIdx,PG) = ddSP;
    ps.PV.store = generatorData;
    ps.runpsat('pf');
    ps.fm_abcd();
    [~, drs(i)] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);
    if PRINT
        % calculate angle (in rad)
        delta = pi/(nPG+1) * i;
        % x,y displacement components
        x = 0.004*sin(delta);
        y = 0.4*cos(delta);
        % drs(i) would be better ? 
        probePlots{i} = DirectedWalks.plot.plotDwUpdate(ax,plotIdx+y,curDR+x,pr,ddSP(i));
        frame = getframe(gcf);
        imIdx = length(im)+1;
        im{imIdx} = frame2im(frame);
    end
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
    [~, drs(i+nPG)] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);
     if PRINT
        % calculate angle (in rad)
        delta = pi/(nPG+1) * i;
        % x,y displacement components
        x = 0.004*sin(delta);
        y = 0.4*cos(delta);
        % drs(i) would be better ? 
        probePlots{i+nPG} = DirectedWalks.plot.plotDwUpdate(ax,plotIdx+y,curDR-x,pr,ddSP(i));
        frame = getframe(gcf);
        imIdx = length(im)+1;
        im{imIdx} = frame2im(frame);
    end
end
% we have a vector of all surrounding Zetas
% calculate the value & idx of direction that minimizes the distance
[~,idx] = min(abs(getDist(drs,'zetaMin',zetaMin)));

if PRINT
    probePlots{idx}.MarkerSize = 4;
    probePlots{idx}.MarkerFaceColor = [0.8500 0.3250 0.0980];
end
% drawnow;
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


desiredPoint = setPoints;
desiredPoint(genIdx) = desiredPoint(genIdx) + sgnDir*mu;
gradV = desiredPoint - setPoints;
grad = (gradV/(norm(gradV)))';
if nargout > 1
    varargout{1} = im;
end
end