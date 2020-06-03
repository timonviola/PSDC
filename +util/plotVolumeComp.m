function plotVolumeComp()
f = figure('name','PSDC','NumberTitle','off');
ax = axes(f);
vols = readtable("case14_1e4_polytope_volumes.csv");
plotVol('case14',{'color','#f9ddb1'},{'color','#ea8601'})
vols =  readtable("case9_1e4_polytope_volumes.csv");
plotVol('case9',{'color','#b8e2f5'},{'color','#4b93c9'})
vols =  readtable("case39_1e4_polytope_volumes.csv");
plotVol('case39',{'color','#ff5f52'},{'color','#8e0000'})
legend()
    function plotVol(caseName,props1,props2)
        x = 1:height(vols);
        xInt = 1:0.1:height(vols);
        d = vols{:,2};
        d = d';
        coef = polyfit(x,d,4);
        volFit = polyval(coef, xInt);


       
        stairs(ax,vols{:,2},'DisplayName',caseName,props1{:})
        hold on
        plot(ax,xInt, volFit,'DisplayName',[caseName ' fit'],props2{:})
        mn = mean(vols{30:end,2});
        h = yline(mn,':',sprintf('Avg: %2.2f',mn),'fontname','Consolas');
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%         simp = movavg(d','linear',5);
%         plot(ax,x,simp,'DisplayName','case14 fit');
    end

set(ax.Children,'LineWidth',1.5)
title('Polytope volume reduction')
xlabel('No. separating hyperplanes')
ylabel('Nominal volume')
set(ax,'fontname','Consolas')
% ax.YGrid = 'on';
% ax.YMinorGrid = 'on';
ax.XLim = [0 105];
end