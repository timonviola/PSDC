function varargout = damp_(As)
% DAMP_ Natural frequency and damping of linear system dynamics.
% [Wn,Z,P] = DAMP_(AS) also returns the poles P of SYS.
% Modified version of MATLAB built in DAMP function. 
% calculate the modal parameeters of A matrix:
%   w_n - undamped natural frequency
%   zeta- damping ratios
%   p   - poles, in case eigenvalues

    try
        [wn,zeta,p] = damp(As);
    catch e
        switch e.identifier
            case 'MATLAB:eig:matrixWithNaNInf'
                As(isnan(As)) = 0;
                [wn,zeta,p] = damp(As);
                warning('NaN replaced with 0.')
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
