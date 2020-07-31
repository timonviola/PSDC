%GETDIST Calculate distance metric.
%   dist = GETDIST(zeta) Return the scalar euclidean distance between zeta 
%   and the default critical damping ratio (zetaMin) = 0.03.
%
%   GETDIST(__,Name,Value) uses additional options specified by one 
%   or more Name-Value pair arguments. Possible name-value pairs:
%     o zetaMin - define the critical damping ratio (default = 0.03)
%
%   Example
%     import DirectedWalks.getDist
%     getDist(0.03,'zetaMin',0.015)
%
%   See also DIRECTEDWALKS.DWF
%

% Copyright (C) 2020 Timon Viola
function dist = getDist(currentZeta,varargin)

zetaMinDefault = 0.03;
p = inputParser;
addRequired(p,'currentZeta',@(x) isnumeric(x))
addOptional(p,'zetaMin',zetaMinDefault , @(x) isnumeric(x))
parse(p,currentZeta,varargin{:});
currentZeta = p.Results.currentZeta;
zetaMin = p.Results.zetaMin;

dist = abs(zetaMin - currentZeta);
end