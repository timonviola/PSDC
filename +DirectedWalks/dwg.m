% Directed walk algorithm
% From: Me
%
% OBJECTIVE: Define stability boundary of N-dimensional space accurately.
%
% DESCRIPTION
% Greedy step direction calculation - takes the first direction that
% provides a smaller DR than the current one (smaller is defined in % using
%   a tuning parameter).
%
% The algorithm starts from S points in the N dimensional space. The
% algorithm runs parallel starting from each S.
% Starting from S the algorithm starts to CHECK into each direction
% at the first stable point it steps into this direction.
% 
% 
% o CHECK
%   Evaluate feasibility of the setpoint (e.g.: SSS and AC-OPF)
%
% o STOPPING CRITERIA
%   R violation - a neighbouring S (seeds) radius is reached
%   W violation - W /Omega/ number of samples are reached
% 
% 
% 
% 
% 
% 
% mu    - step size (constant for now)
% mu_s  - sub step size (constant for now)
% S     - starting points (seeds)
% N     - number of dimensions
% zeta  - critical (damping ratio) limit
% R     - hyper radius of S starting point, if the distance of any L (leaf)
%       is larger than R the current subprocess backpropagates to another 
%       direction. This serves as a stopping criterion.
%