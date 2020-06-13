function alpha = getAlpha(MPC,varargin)
% GETALPHA(MPC) Return alpha discretization ratio. In each dimension alpha
% is 1% of the corresponding decision variable's range from MPC.
% GETALPHA(MPC,scale) Return alpha as each element is scale% of the
% decision variables range (must be positive).
%
% See also DIRECTEDWALKS.DWF

alphaScaleDefault = 1;
p = inputParser;
addRequired(p,'MPC',@(x) isstruct(x))
addOptional(p,'alphaScale',alphaScaleDefault, @(x)validateattributes(x,...
    {'numeric'},{'nonempty','positive'}))
parse(p,MPC,varargin{:});
MPC = p.Results.MPC;
alphaScale = p.Results.alphaScale;

PMAX = 9;
PMIN = 10;
MPC.gen(:,[PMAX,PMIN]);
% do not change the slack bus
genIdx = util.getGenList(MPC);
genRanges = MPC.gen(genIdx,[PMAX,PMIN])./MPC.baseMVA;
% "Explicit is better than implicit" - PEP20
% alpha is 1 percent of each generator's range.
alpha = (genRanges(:,1) - genRanges(:,2))./100 .* alphaScale;
end