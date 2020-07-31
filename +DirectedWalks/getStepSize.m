% GETSTEPSIZE(dist,PMAX) Return the current step size vector based on the
% eucledian distance dist from the desired target. The step size vector is
% a ratio of the PMAX vector.
%
% GETSTEPSIZE(__,'dLims',dLims) Redefines the distance intervals.
% The default distance limits are
% D_1 = 0.05;
% D_2 = 0.01;
% D_3 = 0.0025;
%
% GETSTEPSIZE(__,'eLims',epsLims) Redefines the epsilon values that reduce
% the step size based on the distance. The default epsilon factors are
% E_1 = 0.02;
% E_2 = 0.01;
% E_3 = 0.005;
% E_4 = 0.0025;
%
% See also DIRECTEDWALKS.DWF

% Copyright (c) 2020 Timon Viola
function step = getStepSize(dist,PMAX,varargin)

% CONSTANTS
% step related constants
DDefault(1) = 0.05;
DDefault(2) = 0.01;
DDefault(3) = 0.0025;%0.001; % D_min
% epsilons
% EXPERIMENTAL VALUES:
EDefault(1) = 0.02;
EDefault(2) = 0.01;
EDefault(3) = 0.005;
EDefault(4) = 0.0025;

p = inputParser;
addRequired(p,'dist',@(x) isnumeric(x) && isscalar(x))
addRequired(p,'PMAX',@(x) isnumeric(x) && isvector(x))
addParameter(p,'dLims',DDefault, @(x) isnumeric(x) && isvector(x));
addParameter(p,'epsLims',EDefault, @(x) isnumeric(x) && isvector(x));
parse(p,dist,PMAX,varargin{:})
dist = p.Results.dist;
PMAX = p.Results.PMAX;
D = p.Results.dLims;
E = p.Results.epsLims;
% SAFE VALUES- BUT CONVERGES TOO SLOW ON MIN_DIST 0.0025
% E_1 = 0.01;
% E_2 = 0.005;
% E_3 = 0.001;
% E_4 = 0.0005;

step = 0;   %#ok
if dist > D(1)
    step = PMAX.*E(1);
elseif D(1) >= dist && dist > D(2)
    step = PMAX.*E(2);
elseif D(2) >= dist && dist > D(3)
    step = PMAX.*E(3);
else
    step = PMAX.*E(4);
end
end