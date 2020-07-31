% DEPRECATED 

% Copyright (C) 2020 Timon Viola
function Asys = getAsys()
% GETASYS return system matrix.
%
%   GETASYS wraps around PSAT global variables.
global LA

fm_abcd;        % build ABCD model
Asys = LA.a;    % get A matrix

end