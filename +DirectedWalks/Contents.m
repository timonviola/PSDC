% +DIRECTEDWALKS
% Version 1.0.0 10-Jul-2020
%
% Copyright 2020 Timon Viola
%
% Files
%   checkOPFLimits   - Check OPF limits.
%   checkSetpoint    - Check setpoint feasibility.
%   dwf              - Directed walk algorithm specification.
%   dwf_f            - Directed walk function.
%   dwf_s            - Development implementation of brute force directed walk algorithm.
%   normSpeedTest    - Norm calculation benchmar script.
%   dwg              - Directed walk algorithm
%   dwg_f            - Greedy directed walk function implementation.
%   dwg_f2           - Greedy directed walk function considering AC-OPF limits.
%   dwg_s            - DWF_G Development implementation of brute force directed walk algorithm.
%   getAlpha         - Compute the discretization factor.
%   getDist          - Calculate distance metric.
%   getGreedy        - Greedy computation of step direction.
%   getGreedyLims    - Greedy computation of step direction.
%   getHICSamples    - Get dense samples around setPoints
%   getHICSamplesRnd - Return random samples around setpoint.
%   getStepDir       - Brute-force computation of step direction.
%   getStepDirPV     - Brute-force computation of step direction.
%   getStepSize      - GETSTEPSIZE(dist,PMAX) Return the current step size vector based on the
%   limitsViolated   - Check PG,VG limit violations.
%   test_dwf         - test directed walk brute force function
%   test_dwg         - test directed walk greedy function








