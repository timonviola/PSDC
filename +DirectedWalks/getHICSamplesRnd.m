%GETHICSAMPLESRND Return random samples around setpoint.
%   samples = GETHICSAMPLESRND(setPoint, MPC) Returns randomized samples
%   around the input set point.
% 
%   Example
%      import DirectedWalks.getHICSamplesRnd
%      mmc = loadcase('case_files/case14.m')
%      setP = [ 0.52  0.12  0.29  0.8  0.97  0.96  0.99  0.94  0.94];
%      getHICSamplesRnd(setP, mmc)
% 
%   See also DIRECTEDWALKS.DWF, DIRECTEDWALKS.GETHICSAMPLES
 
% Copyright (C) 2020 Timon Viola
function samples = getHICSamplesRnd(setPoint, MPC, varargin)

% TODO: write input parser with N,tol parameters
N = 1e3;
tol = 0.01;

samples = rand(N,length(setPoint));
alpha = DirectedWalks.getAlpha(MPC);
% scale
samples = samples.*alpha' + setPoint;

samples = uniquetol(samples,tol,'ByRows',true);