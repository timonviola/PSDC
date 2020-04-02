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

d = limit * 100;
y = @(x) x*(sqrt(1e4-d^2)/d);

xv = linspace(0,axh.XLim(1),100);
defaultAxesStyle = {'LineStyle','--',...
    'Color','0.85,0.33,0.10',...
    'HandleVisibility','off'};
ph(1) = plot(xv,y(xv),defaultAxesStyle{:});
ph(2) = plot(xv,-1*y(xv),defaultAxesStyle{:});

if nargout
    varargout{1} = ph;
end