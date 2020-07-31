% Get elapsed time string.
%
% Copyright (C) 2020 Timon Viola
function str = getTimeElapsed(tIn)
str = sprintf('%08.4f',toc(tIn));