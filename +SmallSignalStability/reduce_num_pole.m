function [zeta,poles] = reduce_num_pole(zeta,poles)
% Eliminiate pole due to numerical error

tol = 1e-7;
imTol = 0;
fixVal = -1e3;
fixValZ = 1;

idx = abs(real(poles))<tol & imag(poles)==imTol;
poles(idx) = fixVal;
zeta(idx) = fixValZ;