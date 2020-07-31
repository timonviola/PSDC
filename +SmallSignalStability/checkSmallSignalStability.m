% CHECKSMALLSIGNALSTABILITY Small signal stability of power system. 
%
%   [isStable, dr] = CHECKSMALLSIGNALSTABILITY(DR_LIM,ASYS) checks if the
%   smallest damping ratio of ASYS is larger or equal to DR_LIM. Returns 
%   true if DR_LIM <= min(zeta). 
%       DR_LIM -    is the critical damping ratio in absolute value
%       ASYS   -    is the power system matrix

% Copyright (C) 2020 Timon Viola
function varargout = checkSmallSignalStability(dr_lim,Asys)


% calculate the modal parameters of A matrix:
%   w_n - undamped natural frequency
%   zeta- damping ratios
%   p   - poles, in case eigenvalues
[~, zeta, ~] = SmallSignalStability.damp_(Asys);


minZeta = min(zeta);
isStable = minZeta >= dr_lim;
if nargout>0
    varargout{1} = isStable;
end
if nargout>1
    varargout{2} = minZeta;
end
end