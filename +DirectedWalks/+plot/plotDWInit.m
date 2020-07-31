% Initialize DW plot.

% Copyright (C) 2020 Timon Viola
function varargout = plotDWInit(varargin)

p = inputParser;
zetaMinDefault = 0.03;
hicTolDefault = 0.0025;

addParameter(p,'legend',false,@(x) islogical(x))
addParameter(p,'zetaMin',zetaMinDefault,@(x) isnumeric(x))
addParameter(p,'hicTol',hicTolDefault,@(x) isnumeric(x))

parse(p,varargin{:})
LEG = p.Results.legend;
zetaMin = p.Results.zetaMin;
hicTol = p.Results.hicTol;

f = figure('WindowStyle','docked');
ax = axes;
hold on
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
ylabel('Iteration no.')
xlabel('Damping ratio')
set(ax,'fontname','Consolas')
ax.XGrid = 'on';
ax.XMinorGrid = 'on';
drLim = xline(zetaMin,':','linewidth',1.5,'color','#ff9800');
ax.XLim = [-0.10 0.10];
hicU = xline(zetaMin + hicTol,':','linewidth',1.5,'color','#ffc107','DisplayName','HIC');
hicL = xline(zetaMin - hicTol,':','linewidth',1.5,'color','#ffc107','HandleVisibility','off');

ax.YLim = [-0.5,30];

prop = DirectedWalks.plot.unfeasibleProps();
unFes = plot(0,0,prop{:},'Visible','off');

gr = DirectedWalks.plot.greenProps();
fes = plot(0,0,gr{:},'Visible','off');

pr = DirectedWalks.plot.probeProps();
probe = plot(0,0,pr{:},'Visible','off');

if LEG
    legend([hicU,drLim,unFes,fes,probe],...
        sprintf('DR %04.2f%%',zetaMin * 100), ...
        sprintf('HIC \\pm%.2g',hicTol),...
        'unfeasible','feasible','probe',...
        'AutoUpdate','off','Location','southwest')
end

if nargout 
    varargout{1} = f;
end
if nargout > 1
    varargout{2} = ax;
end
if nargout > 2
    varargout{3} = prop;
end
if nargout > 3 
    varargout{4} = {drLim; hicU; hicL};
end

end