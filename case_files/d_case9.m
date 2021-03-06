% D_009_DYN  WSCC 9 BUS 3 machine test system
%   original system data available at:
%           P.W.Sauer, M.A.Pai Power System Dynamics and Stability
% 
%  
%
%   This test file is originally taken from PSAT v2.1.11. and formatted,
%   but the values are adjusted to MATPOWER case9.
% 


Bus.con = [ ... 
% bus no.   Vbase   V0      Th0   area no.  Reg no.      
1  16.5   1    0    4    1;  
2  18     1    0    5    1;  
3  13.8   1    0    3    1;  
4  230    1    0    2    1;  
5  230    1    0    2    1;  
6  230    1    0    2    1;  
7  230    1    0    2    1;  
8  230    1    0    2    1;  
9  230    1    0    2    1 ];

Line.con = [ ... 
% From bus  To bus      S rating    V rating    f[Hz]  length (0 if pu) -           r           x               b           -       -  Imax     Pmax    Smax    u(connection stat)
9        8      100      230       60        0        0   0.0119   0.1008    0.209        0        0        0        0        0;  
7        8      100      230       60        0        0   0.0085    0.072    0.149        0        0        0        0        0;  
9        6      100      230       60        0        0    0.039     0.17    0.358        0        0        0        0        0;  
7        5      100      230       60        0        0    0.032    0.161    0.306        0        0        0        0        0;  
5        4      100      230       60        0        0     0.01    0.085    0.176        0        0        0        0        0;  
6        4      100      230       60        0        0    0.017    0.092    0.158        0        0        0        0        0;  
2        7     100       18        60        0    0.0782609       0  0.0625       0       0       0       0       0       0;  
3        9     100       13.8      60        0    0.06       0  0.0586       0       0       0       0       0       0;  
1        4     100       16.5      60        0    0.0717391       0  0.0576       0       0       0       0       0       0 ];

SW.con = [ ... 
%bus no.    S rating    Vrating     V0      Th0     Qmax    Qmin    Vmax    Vmin    Pg0     gamma   z   u
1     100    16.5    1.04       0      99     -99     1.1     0.9     0.8       1 ];

PV.con = [ ... 
% bus no    Srating     Vrating     Pg      V0      Qmax    Qmin    Vmax    Vmin    gamma   u   P=(1+gamma*kG)Pg
2     100      18    1.63   1.025      99     -99     1.1     0.9       1;  
3     100    13.8    0.85   1.025      99     -99     1.1     0.9       1 ];

PQ.con = [ ... 
% bus no    Srating     Vrating     Pload   Qload   Vmax    Vmin    z   u
6      100      230      0.9      0.3      0.3      0.8        0;  
8      100      230        1     0.35      0.35     0.8        0;  
5      100      230     1.25      0.5      0.3      0.8        0 ];

Syn.con = [ ... 
% Bno Srat  Vn    fn    -     xl        ra      xd        xd'     xd''    T'd0  T''d0   xq      x'q    x''q   T'q0  T''q0   M=2H    D   Kw  Kp  gammaP  gammaQ  TAA   S(1.0)  S(1.2)
2     100      18      60       4       0       0  0.8958  0.1198       0       6       0  0.8645  0.1969       0   0.535       0    12.8       0       0       0       1       1   0.002;  
3     100    13.8      60       4       0       0  1.3125  0.1813       0    5.89       0  1.2578    0.25       0     0.6       0    6.02       0       0       0       1       1   0.002;  
1     100    16.5      60       4       0       0   0.146  0.0608       0    8.96       0  0.0969  0.0969       0    0.31       0   47.28       0       0       0       1       1   0.002 ];

Tg.con = [ ...
2       2       1      0.05    1.0    0.1   0.1      0.3;
3       2       1      0.05    1.0    0.1   0.1      0.3];

Exc.con = [ ... 
% genNo AVR type  VrMax     VrMin   Ka      Ta        Kf        Tf    -     Te      Tr        Ae          Be
2       2       5      -5      20     0.2   0.063    0.35    0.01   0.314   0.001  0.0039   1.555;  
1       2       5      -5      20     0.2   0.063    0.35    0.01   0.314   0.001  0.0039   1.555;  
3       2       5      -5      20     0.2   0.063    0.35    0.01   0.314   0.001  0.0039   1.555 ];


Varname.bus = {... 
'Bus 1'; 'Bus 2'; 'Bus 3'; 'Bus 4'; 'Bus 5'; 
'Bus 6'; 'Bus 7'; 'Bus 8'; 'Bus 9'};

% 1       1       1      0.05    1.0    0.1   0.1      0.5     0.0    1.25    5];