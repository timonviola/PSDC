% PLOTDWUPDATE update directed walk progress plot
function gObj = plotDwUpdate(i,DR,prop,setPoints)
gObj = plot(DR,i,prop{:});
drawnow;
% custom data tip
gObj.DataTipTemplate.DataTipRows(1).Label = 'DR';
gObj.DataTipTemplate.DataTipRows(2).Label = 'iter';
% add generator rows
NG = floor(length(setPoints)/2);
for k = 1:NG
    addGenDataTip(k)
end

function addGenDataTip(idx)
    % iteratively add data tip row for all generators
    row = dataTipTextRow(['PG' num2str(idx)], setPoints(idx));
    gObj.DataTipTemplate.DataTipRows(end+1) = row;
end
end

