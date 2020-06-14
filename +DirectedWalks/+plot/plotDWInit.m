function varargout = plotDWInit(varargin)

p = inputParser;
addParameter(p,'legend',false,@(x) islogical(x))
parse(p,varargin{:})
LEG = p.Results.legend;

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
drLim = xline(0.03,':','linewidth',1.5,'color','#ff9800');
ax.XLim = [-0.10 0.10];
hicU = xline(0.0325,':','linewidth',1.5,'color','#ffc107','DisplayName','HIC');
hicL = xline(0.0275,':','linewidth',1.5,'color','#ffc107','HandleVisibility','off');

ax.YLim = [0,20];

prop = DirectedWalks.plot.unfeasibleProps();
unFes = plot(0,0,prop{:},'Visible','off');

gr = DirectedWalks.plot.greenProps();
fes = plot(0,0,gr{:},'Visible','off');

pr = DirectedWalks.plot.probeProps();
probe = plot(0,0,pr{:},'Visible','off');

if LEG
    legend([hicU,drLim,unFes,fes,probe],...
        'HIC','DR target','unfeasible','feasible','probe',...
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