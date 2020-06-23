function [grad,varargout] = getStepDirPV(ps, setPoints, curDR, varargin)
% GETSTEPDIRPV Returns the gradient of the new step
% GETSTEPDIRPV Probes both the voltage and the active power setpoints of
% generators.
%
% See also DIRECTEDWALKS.GETSTEPDIR, DIRECTEDWALKS.DWF
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


mu = 0.0005;
nDim = length(setPoints);
drs = nan(2*nDim,1);

if PRINT
    ax = gca;
    plotIdx = max([ax.Children(1:end-3).YData]);
    pr = DirectedWalks.plot.probeProps;
    probePlots = cell(2*nDim,1);
end

for i = 1:nDim
    % set PGs
    ddSP = setPoints;%(1:nPG);
    ddSP(i) = ddSP(i) + mu;
    ps.PVSet(ddSP);

    ps.runpsat('pf');
    ps.fm_abcd();
    [~, drs(i)] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);
    if PRINT
        % calculate angle (in rad)
        delta = pi/(nDim+1) * i;
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
for i = 1:nDim
    % set PGs
    ddSP = setPoints;%(1:nPG);
    ddSP(i) = ddSP(i) - mu;
    ps.PVSet(ddSP);

    ps.runpsat('pf');
    ps.fm_abcd();
    [~, drs(i+nDim)] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);
     if PRINT
        % calculate angle (in rad)
        delta = pi/(nDim+1) * i;
        % x,y displacement components
        x = 0.004*sin(delta);
        y = 0.4*cos(delta);
        % drs(i) would be better ? 
        probePlots{i+nDim} = DirectedWalks.plot.plotDwUpdate(ax,plotIdx+y,curDR-x,pr,ddSP(i));
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
sgnDir = (idx/nDim) <= 1;
if ~sgnDir
    sgnDir = -1;
end
genIdx = mod(idx,nDim);
if genIdx == 0
    genIdx = nDim;
end

% numeric gradient calculation
desiredPoint = setPoints;%(1:nPG);
desiredPoint(genIdx) = desiredPoint(genIdx) + sgnDir*mu;
gradV = desiredPoint - setPoints;%(1:nPG);
grad = (gradV/(norm(gradV)))';
if nargout > 1
    varargout{1} = im;
end
end