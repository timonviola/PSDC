function samples = getHICSamples(setPoint, MPC, varargin)
% GETHICSAMPLES Get dense samples around setPoints
% GETHICSAMPLES(nPG, setPoint, MPC)
% GETHICSAMPLES(nPG, setPoint, MPC,hicSamplingRadius)
% The samples are taken as closest discrete points to setPoint from R^{n}. 
% By default 1% is the discretization factor (with respect to min-max
% values).
% Therefore the sampling radius can be the multiples of the discretization
% factor \alpha.
%
% See also DIRECTEDWALKS.DWF

% radius::Integer (multiple of discretization factor)
rDefault = 1;

p = inputParser;
addRequired(p,'setPoint',@(x)isnumeric(x) && isvector(x))
addRequired(p,'MPC',@(x)isstruct(x))
addOptional(p,'r',rDefault,@(x)validateattributes(x,{'numeric'},...
            {'nonempty','integer','positive'}))
parse(p,setPoint, MPC, varargin{:})

import DirectedWalks.getAlpha


setPoint = p.Results.setPoint;
MPC = p.Results.MPC;
r = p.Results.r;

nDim = length(setPoint);
rVec = [1:r,-1:-1:-1*r];
alpha = getAlpha(MPC);
% 2*r because of +/- direction in each dimension
samples = repmat(setPoint,2*nDim*r,1);
tmp = reshape(rVec,1,1,[]) .* diag(alpha);
c = reshape(tmp,nDim,[]).';
samples(:,1:nDim) = ...
    samples(:,1:nDim) + c;
end