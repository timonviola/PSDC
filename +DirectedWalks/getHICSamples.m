%GETHICSAMPLES Get dense samples around setPoints
%   samples = GETHICSAMPLES(setPoint, MPC) Returns samples along each
%   possible direction of the case file.
% 
%   GETHICSAMPLES(__,Name,Value) uses additional options specified by one 
%   or more Name-Value pair arguments. Possible name-value pairs:
%     o r - HIC sampling radius
%   The samples are taken along each axis' +/- direction. The number of
%   samples taken into each direction is defined by r.
%
%   Example
%     import DirectedWalks.getHICSamples
%     mmc = loadcase('case_files/case14.m')
%     setP = [ 0.52  0.12  0.29  0.8  0.97  0.96  0.99  0.94  0.94];
%     getHICSamples(setP, mmc)
% 
%   See also DIRECTEDWALKS.DWF, DIRECTEDWALKS.GETHICSAMPLESRND
% 

% Copyright (C) 2020 Timon Viola
function samples = getHICSamples(setPoint, MPC, varargin)

rDefault = 1;
% radius::Integer (multiple of discretization factor)

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