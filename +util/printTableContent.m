% PRINTTABLECONTENT Print formatted ASCII table contents.
function printTableContent(nRows, format, data)
    for i = 1:nRows
       fprintf(format,data(i,:));
    end
end