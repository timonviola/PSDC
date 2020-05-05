function varargout = damp_(As)
% DAMP_ Natural frequency and damping of linear system dynamics.
% [Wn,Z,P] = DAMP_(AS) also returns the poles P of SYS.
% Modified version of MATLAB built in DAMP function. 
% calculate the modal parameeters of A matrix:
%   w_n - undamped natural frequency
%   zeta- damping ratios
%   p   - poles, in case eigenvalues
% Dependecies (Tested version):
%   MATLAB                      (9.8)
%   Control System Toolbox      (14.0)


    try
        [wn,zeta,p] = damp(As);
    catch e
        switch e.identifier
            case 'MATLAB:eig:matrixWithNaNInf'
                if sum(any(isnan(As)))
                    As(isnan(As)) = 0;
                    warning('NaN replaced with 0.')
                end
                if sum(any(isinf(As)))
                    As(isinf(As) & As > 0) = 1e40;
                    As(isinf(As) & As < 0) = -1e40;
                    warning('Inf replaced with 1e40.')
                end
                [wn,zeta,p] = damp(As);
            otherwise
                rethrow(e)
        end
    end
    [zeta,p] = SmallSignalStability.reduce_num_pole(zeta,p); % eliminate numerical err
    switch nargout
        case 1
            varargout{1} = wn;
        case 2
            varargout{1} = wn;
            varargout{2} = zeta;
        case 3
            varargout{1} = wn;
            varargout{2} = zeta;
            varargout{3} = p;
        otherwise
            warning('Wrong number of outputs.')
    end
end
