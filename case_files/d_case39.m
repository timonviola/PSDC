% IEEE39 BUS test system 10 GENERATORS
% The original data source of the test system is:
%   https://electricgrids.engr.tamu.edu/electric-grid-test-cases/
%
% The dynamic parameters were compared and adjusted accordingly to IEEE PES-TR18
% Benchmark Systems for Small-Signal Stability Analysis and Control 
%   https://resourcecenter.ieee-pes.org/technical-publications/technical-reports/PESTR18.html
% 
% Timon Viola @ https://github.com/timonviola/PSDC
%
Bus.con = [ ...
      1      345    1.039  -0.2363    2    1;
      2      345    1.048  -0.1708    2    1;
      3      345    1.031  -0.2143    2    1;
      4      345    1.004  -0.2204    1    1;
      5      345    1.006  -0.1953    1    1;
      6      345    1.008  -0.1817    1    1;
      7      345   0.9984  -0.2226    1    1;
      8      345   0.9979  -0.2328    1    1;
      9      345    1.038  -0.2475    1    1;
     10      345    1.018  -0.1426    1    1;
     11      345    1.013   -0.156    1    1;
     12      345    1.001  -0.1571    1    1;
     13      345    1.015  -0.1559    1    1;
     14      345    1.012   -0.187    1    1;
     15      345    1.016   -0.198    3    1;
     16      345    1.033  -0.1751    3    1;
     17      345    1.034   -0.194    2    1;
     18      345    1.032  -0.2092    2    1;
     19      345     1.05 -0.09442    3    1;
     20      345    0.991  -0.1191    3    1;
     21      345    1.032  -0.1331    3    1;
     22      345     1.05 -0.05556    3    1;
     23      345    1.045 -0.05901    3    1;
     24      345    1.038   -0.173    3    1;
     25      345    1.058  -0.1461    2    1;
     26      345    1.053  -0.1647    2    1;
     27      345    1.038  -0.1983    2    1;
     28      345     1.05  -0.1035    3    1;
     29      345     1.05 -0.05532    3    1;
     30      345     1.05  -0.1286    2    1;
     31      345    0.982        0    1    1;
     32      345   0.9841 -0.003289    1    1;
     33      345   0.9972 -0.003372    3    1;
     34      345    1.012 -0.02847    3    1;
     35      345    1.049  0.03101    3    1;
     36      345    1.064  0.07799    3    1;
     37      345    1.028 -0.02763    2    1;
     38      345    1.026  0.06794    3    1;
     39      345     1.03  -0.2537    1    1;
   ];

SW.con = [ ...
     31      100      345    0.982        0        3       -1     1.06     0.94    6.779 1 1  1;
   ];

PV.con = [ ...
  30      100      345      2.5     1.05        4      1.4     1.06     0.94 1  1;
  32      100      345      6.5   0.9841        3      1.5     1.06     0.94 1  1;
  33      100      345     6.32   0.9972      2.5        0     1.06     0.94 1  1;
  34      100      345     5.08    1.012     1.67        0     1.06     0.94 1  1;
  35      100      345      6.5    1.049        3       -1     1.06     0.94 1  1;
  36      100      345      5.6    1.064      2.4        0     1.06     0.94 1  1;
  37      100      345      5.4    1.028      2.5        0     1.06     0.94 1  1;
  38      100      345      8.3    1.026        3     -1.5     1.06     0.94 1  1;
  39      100      345       10     1.03        3       -1     1.06     0.94 1  1;
   ];


% PQ IEEE benchmark
   PQ.con = [ ...
   % Nb Srating Vrating    Pload   Qload     Vmax     Vmin z u
      1 100      345       0           0       1.06     0.94 0 1;
      3 100      345       3.22   0.024   1.06     0.94 0 1;
      4 100      345       5      1.84    1.06     0.94 0 1;
      7 100      345       2.338  0.84    1.06     0.94 0 1;
      8 100      345       5.22   1.766   1.06     0.94 0 1;
      9 100      345       0        0         1.06     0.94 0 1;
     12 100      345       0.075  0.88    1.06     0.94 0 1;
     15 100      345       3.2    1.53    1.06     0.94 0 1;
     16 100      345       3.29   0.323   1.06     0.94 0 1;
     18 100      345       1.58   0.3     1.06     0.94 0 1;
     20 100      345       6.28   1.03    1.06     0.94 0 1;
     21 100      345       2.74   1.15    1.06     0.94 0 1;
     23 100      345       2.74   0.846   1.06     0.94 0 1;
     24 100      345       3.086  -0.922  1.06     0.94 0 1;
     25 100      345       2.24   0.472   1.06     0.94 0 1;
     26 100      345       1.39   0.17    1.06     0.94 0 1;
     27 100      345       2.81   0.755   1.06     0.94 0 1;
     28 100      345       2.06   0.276   1.06     0.94 0 1;
     29 100      345       2.835  0.269   1.06     0.94 0 1;
     31 100      345       0.092  0.046   1.06     0.94 0 1;
     39 100      345       11.04  2.5     1.06     0.94 0 1;
      2 100      345        0        0     1.06     0.94 0 1;
      5 100      345        0        0     1.06     0.94 0 1;
      6 100      345        0        0     1.06     0.94 0 1;
     10 100      345        0        0     1.06     0.94 0 1;
     11 100      345        0        0     1.06     0.94 0 1;
     13 100      345        0        0     1.06     0.94 0 1;
     14 100      345        0        0     1.06     0.94 0 1;
     17 100      345        0        0     1.06     0.94 0 1;
     19 100      345        0        0     1.06     0.94 0 1;
     22 100      345        0        0     1.06     0.94 0 1;
      ];
% PQ original MATPOWER
% PQ.con = [ ...
% % Nb Srating Vrating  Pload   Qload     Vmax     Vmin z u
%    1 100      345    0.976    0.442     1.06     0.94 0 1;
%    3 100      345     3.22    0.024     1.06     0.94 0 1;
%    4 100      345        5     1.84     1.06     0.94 0 1;
%    7 100      345    2.338     0.84     1.06     0.94 0 1;
%    8 100      345     5.22    1.766     1.06     0.94 0 1;
%    9 100      345    0.065   -0.666     1.06     0.94 0 1;
%   12 100      345   0.0853     0.88     1.06     0.94 0 1;
%   15 100      345      3.2     1.53     1.06     0.94 0 1;
%   16 100      345     3.29    0.323     1.06     0.94 0 1;
%   18 100      345     1.58      0.3     1.06     0.94 0 1;
%   20 100      345      6.8     1.03     1.06     0.94 0 1;
%   21 100      345     2.74     1.15     1.06     0.94 0 1;
%   23 100      345    2.475    0.846     1.06     0.94 0 1;
%   24 100      345    3.086   -0.922     1.06     0.94 0 1;
%   25 100      345     2.24    0.472     1.06     0.94 0 1;
%   26 100      345     1.39     0.17     1.06     0.94 0 1;
%   27 100      345     2.81    0.755     1.06     0.94 0 1;
%   28 100      345     2.06    0.276     1.06     0.94 0 1;
%   29 100      345    2.835    0.269     1.06     0.94 0 1;
%   31 100      345    0.092    0.046     1.06     0.94 0 1;
%   39 100      345    11.04      2.5     1.06     0.94 0 1;
%    2 100      345        0        0     1.06     0.94 0 1;
%    5 100      345        0        0     1.06     0.94 0 1;
%    6 100      345        0        0     1.06     0.94 0 1;
%   10 100      345        0        0     1.06     0.94 0 1;
%   11 100      345        0        0     1.06     0.94 0 1;
%   13 100      345        0        0     1.06     0.94 0 1;
%   14 100      345        0        0     1.06     0.94 0 1;
%   17 100      345        0        0     1.06     0.94 0 1;
%   19 100      345        0        0     1.06     0.94 0 1;
%   22 100      345        0        0     1.06     0.94 0 1;
%    ];

Line.con = [ ...
% From bus  To bus      S rating    V rating    f[Hz]  length (0 if pu) -           r           x               b           -       -  Imax     Pmax    Smax    u(connection stat)
   1    2 100      345 60 0         0   0.0035   0.0411   0.6987        0        0        6        6        6  1;
   1   39 100      345 60 0         0    0.001    0.025     0.75        0        0       10       10       10  1;
   2    3 100      345 60 0         0   0.0013   0.0151   0.2572        0        0        5        5        5  1;
   2   25 100      345 60 0         0    0.007   0.0086    0.146        0        0        5        5        5  1;
   2   30 100      345 60 0         1        0   0.0181        0    1.025        0        9        9       25  1;
   3    4 100      345 60 0         0   0.0013   0.0213   0.2214        0        0        5        5        5  1;
   3   18 100      345 60 0         0   0.0011   0.0133   0.2138        0        0        5        5        5  1;
   4    5 100      345 60 0         0   0.0008   0.0128   0.1342        0        0        6        6        6  1;
   4   14 100      345 60 0         0   0.0008   0.0129   0.1382        0        0        5        5        5  1;
   5    6 100      345 60 0         0   0.0002   0.0026   0.0434        0        0       12       12       12  1;
   5    8 100      345 60 0         0   0.0008   0.0112   0.1476        0        0        9        9        9  1;
   6    7 100      345 60 0         0   0.0006   0.0092    0.113        0        0        9        9        9  1;
   6   11 100      345 60 0         0   0.0007   0.0082   0.1389        0        0      4.8      4.8      4.8  1;
   6   31 100      345 60 0         1        0    0.025        0     1.07        0       18       18       18  1;
   7    8 100      345 60 0         0   0.0004   0.0046    0.078        0        0        9        9        9  1;
   8    9 100      345 60 0         0   0.0023   0.0363   0.3804        0        0        9        9        9  1;
   9   39 100      345 60 0         0    0.001    0.025      1.2        0        0        9        9        9  1;
  10   11 100      345 60 0         0   0.0004   0.0043   0.0729        0        0        6        6        6  1;
  10   13 100      345 60 0         0   0.0004   0.0043   0.0729        0        0        6        6        6  1;
  10   32 100      345 60 0         1        0     0.02        0     1.07        0        9        9       25  1;
  12   11 100      345 60 0         1   0.0016   0.0435        0    1.006        0        5        5        5  1;
  12   13 100      345 60 0         1   0.0016   0.0435        0    1.006        0        5        5        5  1;
  13   14 100      345 60 0         0   0.0009   0.0101   0.1723        0        0        6        6        6  1;
  14   15 100      345 60 0         0   0.0018   0.0217    0.366        0        0        6        6        6  1;
  15   16 100      345 60 0         0   0.0009   0.0094    0.171        0        0        6        6        6  1;
  16   17 100      345 60 0         0   0.0007   0.0089   0.1342        0        0        6        6        6  1;
  16   19 100      345 60 0         0   0.0016   0.0195    0.304        0        0        6        6       25  1;
  16   21 100      345 60 0         0   0.0008   0.0135   0.2548        0        0        6        6        6  1;
  16   24 100      345 60 0         0   0.0003   0.0059    0.068        0        0        6        6        6  1;
  17   18 100      345 60 0         0   0.0007   0.0082   0.1319        0        0        6        6        6  1;
  17   27 100      345 60 0         0   0.0013   0.0173   0.3216        0        0        6        6        6  1;
  19   20 100      345 60 0         1   0.0007   0.0138        0     1.06        0        9        9       25  1;
  19   33 100      345 60 0         1   0.0007   0.0142        0     1.07        0        9        9       25  1;
  20   34 100      345 60 0         1   0.0009    0.018        0    1.009        0        9        9       25  1;
  21   22 100      345 60 0         0   0.0008    0.014   0.2565        0        0        9        9        9  1;
  22   23 100      345 60 0         0   0.0006   0.0096   0.1846        0        0        6        6        6  1;
  22   35 100      345 60 0         1        0   0.0143        0    1.025        0        9        9       25  1;
  23   24 100      345 60 0         0   0.0022    0.035    0.361        0        0        6        6        6  1;
  23   36 100      345 60 0         1   0.0005   0.0272        0        1        0        9        9       25  1;
  25   26 100      345 60 0         0   0.0032   0.0323    0.531        0        0        6        6        6  1;
  25   37 100      345 60 0         1   0.0006   0.0232        0    1.025        0        9        9       25  1;
  26   27 100      345 60 0         0   0.0014   0.0147   0.2396        0        0        6        6        6  1;
  26   28 100      345 60 0         0   0.0043   0.0474   0.7802        0        0        6        6        6  1;
  26   29 100      345 60 0         0   0.0057   0.0625    1.029        0        0        6        6        6  1;
  28   29 100      345 60 0         0   0.0014   0.0151    0.249        0        0        6        6        6  1;
  29   38 100      345 60 0         1   0.0008   0.0156        0    1.025        0       12       12       25  1;
   ];

Supply.con = [ ...
  30       100        0     10.4        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  31       100        0     6.46        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  32       100        0     7.25        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  33       100        0     6.52        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  34       100        0     5.08        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  35       100        0     6.87        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  36       100        0      5.8        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  37       100        0     5.64        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  38       100        0     8.65        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
  39       100        0       11        0        0      0.2      0.3     0.01        0        0        0  1 0 1;
   ];

Bus.names = {...
      'Bus 1'; 'Bus 2'; 'Bus 3'; 'Bus 4'; 'Bus 5'; 
      'Bus 6'; 'Bus 7'; 'Bus 8'; 'Bus 9'; 'Bus 10'; 
      'Bus 11'; 'Bus 12'; 'Bus 13'; 'Bus 14'; 'Bus 15'; 
      'Bus 16'; 'Bus 17'; 'Bus 18'; 'Bus 19'; 'Bus 20'; 
      'Bus 21'; 'Bus 22'; 'Bus 23'; 'Bus 24'; 'Bus 25'; 
      'Bus 26'; 'Bus 27'; 'Bus 28'; 'Bus 29'; 'Bus 30'; 
      'Bus 31'; 'Bus 32'; 'Bus 33'; 'Bus 34'; 'Bus 35'; 
      'Bus 36'; 'Bus 37'; 'Bus 38'; 'Bus 39'};

Syn.con = [ ... 
% see table 15.1 and 15.2
% Bno   Srat  Vn  fn |mdl typ   xl      ra          xd        xd'     xd''    T'd0  T''d0   xq      x'q    x''q   T'q0  T''q0   M=2H          D   Kw  Kp  gammaP  gammaQ  TAA   S(1.0)  S(1.2)
    39,  2000, 1, 60,    4,    0.003    0          0.02       0.006    1       7      0    0.019    0.008   0      0.7    0     1000.0000     19   0.5   0   1       1       0       0       0;    % G1
    31,  200,  1, 60,    4,    0.035    0          0.295      0.0697   1       6.56   0    0.282    0.17    0      1.5    0     60.6000       19   0.5   0   1       1       0       0       0;    % G2
    32,  200,  1, 60,    4,    0.0304   0          0.2495     0.0531   1       5.7    0    0.237    0.0876  0      1.5    0     71.6000       19   0.5   0   1       1       0       0       0;    % G3
    33,  200,  1, 60,    4,    0.0295   0          0.262      0.0436   1       5.69   0    0.258    0.166   0      1.5    0     57.2000       19   0.5   0   1       1       0       0       0;    % G4
    34,  200,  1, 60,    4,    0.054    0          0.67       0.132    1       5.4    0    0.62     0.166   0      0.44   0     52.0000       19   0.5   0   1       1       0       0       0;    % G5
    35,  200,  1, 60,    4,    0.0224   0          0.254      0.05     1       7.3    0    0.241    0.0814  0      0.4    0     69.6000       19   0.5   0   1       1       0       0       0;    % G6
    36,  200,  1, 60,    4,    0.0322   0          0.295      0.049    1       5.66   0    0.292    0.186   0      1.5    0     52.8000       19   0.5   0   1       1       0       0       0;    % G7
    37,  200,  1, 60,    4,    0.028    0          0.29       0.057    1       6.7    0    0.28     0.0911  0      0.41   0     48.6000       19   0.5   0   1       1       0       0       0;    % G8
    38,  200,  1, 60,    4,    0.0298   0          0.2106     0.057    1       4.79   0    0.205    0.0587  0      1.96   0     69.0000       19   0.5   0   1       1       0       0       0;    % G9
    30,  200,  1, 60,    4,    0.0125   0          0.1        0.031    1       10.2   0    0.069    0.008   0      0      0     84.0000       19   0.5   0   1       1       0       0       0;    % G10  
 ];
% AVR data
 Exc.con = [ ... 
 %genNo AVR type  VrMax     VrMin   Ka       Ta       Kf     Tf       -    Te     Tr        Ae          Be   u
 %  12     2      4.0       0.00   100      100       0.01   100     0.0   0.09  0.01         0         0 ;
   1,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   2,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   3,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   4,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   5,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   6,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   7,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   8,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   9,      1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
   10,     1,     5.0,     -5.0,   200.0,   0.015,    1.0,  1.0,     1.0,  1.0,   0.01,     0.001,       -0.1, 1;
 ];


Pss.con = [...
%AVR num    PPS model   pss input   VMAX    VMIN        Kw         Tw      T1    T2     T3    T4      Ka Ta Kp Kv Vamax V*amax   Vs*max   Vs*min   ethr  wthr  s2 u
   1,            2,        1,       0.2,   -0.2,   1.0/(120*pi),   10.0,   5.0,  0.60,  3.0,  0.50,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   2,            2,        1,       0.2,   -0.2,   0.5/(120*pi),   10.0,   5.0,  0.40,  1.0,  0.10,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   3,            2,        1,       0.2,   -0.2,   0.5/(120*pi),   10.0,   3.0,  0.20,  2.0,  0.20,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   4,            2,        1,       0.2,   -0.2,   2.0/(120*pi),   10.0,   1.0,  0.10,  1.0,  0.30,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   5,            2,        1,       0.2,   -0.2,   1.0/(120*pi),   10.0,   1.5,  0.20,  1.0,  0.10,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   6,            2,        1,       0.2,   -0.2,   4.0/(120*pi),   10.0,   0.5,  0.10,  0.5,  0.05,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   7,            2,        1,       0.2,   -0.2,   7.5/(120*pi),   10.0,   0.2,  0.02,  0.5,  0.10,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   8,            2,        1,       0.2,   -0.2,   2.0/(120*pi),   10.0,   1.0,  0.20,  1.0,  0.10,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   9,            2,        1,       0.2,   -0.2,   2.0/(120*pi),   10.0,   1.0,  0.50,  2.0,  0.10,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
   10,           2,        1,       0.2,   -0.2,   1.0/(120*pi),   10.0,   1.0,  0.05,  3.0,  0.50,   1,  1, 1, 1, 1,   1,       1,       1,       1,    1,    1, 1;
];