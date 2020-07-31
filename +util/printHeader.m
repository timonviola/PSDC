% PRINTDATASUMMARY Formatted output of plotDataSummary.
% See also UTIL.PLOTDATASUMMARY

% Copyright (C) 2020 Timon Viola
function printHeader(varargin)
if nargin > 2
   tFormat = varargin{3};
   title = varargin{4};
   fprintf(tFormat,title);
end
if nargin > 1
   % {} header given 
    hFormat = varargin{1};
    header = varargin{2};
    fprintf(hFormat,header{:});
end


