%GETALPHA Compute the discretization factor.
%   df = GETALPHA(MPC) Return alpha discretization factor. In each dimension
%   alpha is 1% of the corresponding decision variable's min-max range. The
%   range is extracted from the MPC MATPOWER struct.
% 
%   GETALPHA(__,Name,Value) uses additional options specified by one or more 
%   Name-Value pair arguments. Possible name-value pairs:
%     o alphaScale - scaling factor of 1% of the decision variables range.
% 
%   Example
%     import DirectedWalks.getAlpha
%     mmc = loadcase('case_files/case14.m');
%     getAlpha(mmc)
% 
%   See also DIRECTEDWALKS.DWF
%

% Copyright (C) 2020 Timon Viola
function alpha = getAlpha(MPC,varargin)

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

% voltages:
VMAX = 12;
VMIN = 13;
allGIdx = MPC.gen(:,1);
vRanges = [MPC.bus(allGIdx,VMAX),MPC.bus(allGIdx,VMIN)];

% "Explicit is better than implicit" - PEP20
% alpha is 1 percent of each generator's range.
alpha = [(genRanges(:,1) - genRanges(:,2))./100 .* alphaScale;
    (vRanges(:,1) - vRanges(:,2))./100 .* alphaScale];
end