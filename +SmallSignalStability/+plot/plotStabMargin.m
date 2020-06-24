function varargout=plotStabMargin(limit,varargin)
% PLOTSTABMARGIN Plot stability margin of damping ration given by LIMIT.

p = inputParser;
isInBounds = @(x) abs(x) <= 1;
defaultAxes = gca;
validAxes = @(x) isa(x,'matlab.graphics.axis.Axes');
addRequired(p,'limit',isInBounds)
addOptional(p,'axh',defaultAxes,validAxes)
parse(p,limit,varargin{:});

limit = p.Results.limit;
axh = p.Results.axh;

% preserve yLimits
yLimits = axh.YLim;

d = limit * 100;
y = @(x) x*(sqrt(1e4-d^2)/d);

xv = linspace(0,axh.XLim(1),100);
defaultAxesStyle = {'LineStyle','--',...
    'Color','0.85,0.33,0.10',...
    'HandleVisibility','off',...
    'PickableParts','none',... % user can't click so it's easier
    'HitTest','off'}; % to open eigenvalues context menu
ph(1) = plot(xv,y(xv),defaultAxesStyle{:});
ph(2) = plot(xv,-1*y(xv),defaultAxesStyle{:});

axh.YLim = yLimits;
if nargout
    varargout{1} = ph;
end