% PLOTDWUPDATE update directed walk progress plot
function gObj = plotDwUpdate(ax,i,DR,prop,setPoints)
gObj = plot(ax,DR,i,prop{:});
drawnow;
% custom data tip
gObj.DataTipTemplate.DataTipRows(1).Label = 'DR';
gObj.DataTipTemplate.DataTipRows(2).Label = 'iter';
% add generator rows
NG = floor(length(setPoints)/2);
for k = 1:NG
    gObj = DirectedWalks.plot.addGenDataTip(k,gObj,setPoints);
end


end
