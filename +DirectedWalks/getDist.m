function dist = getDist(currentZeta,varargin)
% GETDIST(zeta) Retrun the scalar eucledian distance between zeta and the
% default zetaMin = 0.03.
%
% GETDIST(zeta, zetaMin) Retrun the scalar eucledian distance between zeta 
% and zetaMin.
%
% See also DIRECTEDWALKS.DWF

zetaMinDefault = 0.03;
p = inputParser;
addRequired(p,'currentZeta',@(x) isnumeric(x))
addOptional(p,'zetaMin',zetaMinDefault , @(x)validateattributes(x,...
    {'numeric'}))
parse(p,currentZeta,varargin{:});
currentZeta = p.Results.currentZeta;
zetaMin = p.Results.zetaMin;

dist = abs(zetaMin - currentZeta);
end