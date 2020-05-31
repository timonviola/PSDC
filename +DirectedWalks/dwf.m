% Directed walk algorithm
% From: Efficient Database Generation for Data-driven
%       Security Assessment of Power Systems
%
% OBJECTIVE: Define stability boundary of N-dimensional space accurately.
%
% DESCRIPTION
% Determine alpha_k current STEP SIZE. Determine STEP DIRECTION. The next
% operating point is defined as OP_{k+1} = OP_k + alpha_k*GRAD(d(OP_k)).
% The directed walk is supposed to find gamma and proceed along the
% boundary with a small step size to take a large number of set points. If
% K_max steps are reached the algorithm is terminated.
%
%
% o DISTANCE FROM OPERATING POINT
%   Distance of operating point k (OP_k) = |gamma_k - gamma| where gamma_k
%   is the stability index of OP_k. The eucledian norm of stability
%   vectors.
%
% o STEP SIZE
%   Based on the DISTANCE FROM OPERATING POINT the k-th step size is
%   determined as follows:
%              epsilon_1 * P^{max} if        d(OP_k) > d_1
%              epsilon_2 * P^{max} if d_1 >= d(OP_k) > d_2
%              epsilon_3 * P^{max} if d_2 >= d(OP_k) > d_3
%              epsilon_4 * P^{max} else
%   where d_1 > d_2 > d_3 consequently epsilon_1 > eps_2 > eps_3 > eps_4
%   holds, to ensure that a finer step size is taking when the distance is
%   smaller.
%
% o STEP DIRECTION
%   Every step the most critical contingency is assumed. The steepest
%   descent of the distance metric d(OP_k) is followed:
%       direction = GRAD(d(OP_k))
%   
% o GRAD(d(OP_k))
%   In a proper algorithm this would be a general gradient. Here additional
%   definition is neccessary*. We end up with the following: from OP_k
%   check in each direction of generators (+/- G )the value of zeta and
%   follow the smallest one.
%
% * There is lots of talk in the paper alon the lines: Sensitivity 
%   measure for small-signal stability: the direction is determined by the 
%   sensitivity of the damping ratio zeta. This is obtained by calculating
%   the EIGENVALUE SENSITIVITY (of the most critical case's system matrix).
%   But this is computationally too hard so we don't do this.


% alpha     - variable step size
% d         - distance from security boundary
% gamma     - security boundary
% epsilon   - scaling factor (constant scalars)
% P^{max}   - vector of generator maximum capacities
% zeta      - damping ratio (small signal stability)
% G         - number of generators as decision variables (slack excluded)
% K_max     - maximum number of steps