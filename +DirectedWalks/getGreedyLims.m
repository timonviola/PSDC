%GETGREEDYLIMS Greedy computation of step direction.
%   grad = GETGREEDYLIMS(ps, setPoints, currentDR) returns the gradient of
%   the next directed walk step which has a good-enough distance reduction
%   only if the step in that direction would not violated ACOPF limits. ps
%   is an oopsat instance, setPoints is the ordered vector of set points
%   and currentDR is the current steps damping ratio.
% 
%   GETGREEDYLIMS(__,Name,Value) uses additional options specified by one 
%   or more Name-Value pair arguments. Possible name-value pairs:
%     o zetaMin - [numeric] define critical damping ratio (default = 0.03)
%     o print - [logical] Plot the progress of the gradient calculation
%               (default = false)
%     o imwrite - Pass cell of image snapshots if a .gif file is going to
%                 be written from the progress plot.
% 
%   Example
%     
% 
% See also DIRECTEDWALKS.DWF
% 

% Copyright (C) 2020 Timon Viola


function [grad,varargout] = getGreedyLims(ps, setPoints, curDR, mmc,...
    alpha_k, varargin)


import DirectedWalks.getDist
import DirectedWalks.limitsViolated

zetaMinDefault = 0.03;
printDefault = false;
imDefault = {};
p = inputParser;
addRequired(p,'ps')
addRequired(p,'setPoints')
addRequired(p,'curDR')
addRequired(p,'mmc')
addRequired(p,'alpha_k')
addOptional(p,'zetaMin',zetaMinDefault,@(x) isnumeric(x))
addParameter(p,'print',printDefault, @(x)islogical(x))
addParameter(p,'imwrite',imDefault)
parse(p,ps,setPoints,curDR,mmc,alpha_k,varargin{:})

ps = p.Results.ps;
setPoints = p.Results.setPoints;
curDR = p.Results.curDR;
mmc = p.Results.mmc;
alpha_k = p.Results.alpha_k;
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