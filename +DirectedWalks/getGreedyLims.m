function [grad,varargout] = getGreedyLims(ps, setPoints, curDR, mmc,alpha_k, varargin)
% GETSTEPDIR Return the gradient of the new step.
% calculate SSS for 2*nPG direction of N-dimensional space
%
% See also DIRECTEDWALKS.DWF
import DirectedWalks.getDist
import DirectedWalks.limitsViolated

zetaMinDefault = 0.03;
printDefault = false;
imDefault = {};
p = inputParser;
addRequired(p,'ps')
addRequired(p,'setPoints')
addRequired(p,'curDR')
addOptional(p,'zetaMin',zetaMinDefault,@(x) isnumeric(x))
addParameter(p,'print',printDefault, @(x)islogical(x))
addParameter(p,'imwrite',imDefault)
parse(p,ps,setPoints,curDR,varargin{:})

ps = p.Results.ps;
setPoints = p.Results.setPoints;
curDR = p.Results.curDR;
zetaMin = p.Results.zetaMin;
PRINT = p.Results.print;
im = p.Results.imwrite;


% small perturbation applied to G
mu = 0.0005;
% if dist is <= than this, we take it
curDist = getDist(curDR);
% GREEDTOL = 0.999995; % TODO: define in percentage
GREEDTOL = 0.996;
isInGreedyTol = @(x) getDist(x,zetaMin) <= curDist*GREEDTOL;
% GREEDYQUIT = false;

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
    ddSP = setPoints;
    ddSP(i) = ddSP(i) + mu;
    gD = zeros(size(setPoints));
    gD(i) = 1;
    nStep = ddSP + (alpha_k' .* gD);
    if ~limitsViolated(nStep,mmc)
        
        ps.PVSet(ddSP);

        ps.runpsat('pf');
        ps.fm_abcd();
        [~, drs(i)] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);
        % ----- PRINT -----
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
         % ---- GREED -----
        if isInGreedyTol(drs(i))
    %         GREEDYQUIT = true;
            break
        end
    end
    % ----- Check [-] direction -----
    ddSP = setPoints;
    ddSP(i) = ddSP(i) - mu;
    gD = zeros(size(setPoints));
    gD(i) = -1;
    nStep = ddSP + (alpha_k' .* gD);
    if ~limitsViolated(nStep,mmc)
        ps.PVSet(ddSP);
    
        ps.runpsat('pf');
        ps.fm_abcd();
        [~, drs(i+nDim)] = SmallSignalStability.checkSmallSignalStability(zetaMin, ps.LA.a);

         % ----- PRINT -----
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
        % ---- GREED -----
        if isInGreedyTol(drs(i))
            break
        end
    end
end

% we have a vector of all surrounding Zetas
% calculate the value & idx of direction that minimizes the distance
[~,idx] = min(abs(getDist(drs,zetaMin)));
probePlots{idx}.MarkerSize = 4;
probePlots{idx}.MarkerFaceColor = [0.8500 0.3250 0.0980];
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

% ----- the real-real mathemtcal gradient -----
%
%      d f(a)   f(a+h) - f(a)
% m = ------ = ---------------
%       d a          h
%
% grad = (drs - curDR)/mu;


desiredPoint = setPoints;
desiredPoint(genIdx) = desiredPoint(genIdx) + sgnDir*mu;
gradV = desiredPoint - setPoints;
grad = (gradV/(norm(gradV)))';
if nargout > 1
    varargout{1} = im;
end
end