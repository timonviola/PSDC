% PRINTHEADER Print ASCII table header.
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


