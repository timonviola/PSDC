function gObj = addGenDataTip(idx,gObj,setPoints)
    % iteratively add data tip row for all generators
    row = dataTipTextRow(['PG' num2str(idx)], setPoints(idx));
    gObj.DataTipTemplate.DataTipRows(end+1) = row;
end