% PRINTTABLECONTENT Print formatted ASCII table contents.

% Copyright (C) 2020 Timon Viola
function printTableContent(nRows, format, data)
    for i = 1:nRows
       fprintf(format,data(i,:));
    end
end