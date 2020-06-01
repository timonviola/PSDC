% IEEE39 BUS test system 10 GENERATORS
% The original data source of the test system is:
%   https://electricgrids.engr.tamu.edu/electric-grid-test-cases/
%
% The dynamic parameters were compared and adjusted accordingly to IEEE PES-TR18
% Benchmark Systems for Small-Signal Stability Analysis and Control 
%   https://resourcecenter.ieee-pes.org/technical-publications/technical-reports/PESTR18.html
% 
% Timon Viola @ https://github.com/timonviola
%

Bus.con = [ ...
% bus no.     Vbase   V0      Th0   area no.  Reg no.    
      1        1    1.049  -0.1461    1    1;
      2        1    1.052  -0.1007    1    1;
      3        1    1.036  -0.1502    1    1;
      4        1    1.017   -0.166    1    1;
      5        1    1.014  -0.1472    1    1;
      6        1    1.011   -0.135    1    1;
      7        1    1.002  -0.1729    1    1;
      8        1    1.002  -0.1816    1    1;
      9        1    1.031  -0.1774    1    1;
     10        1    1.021 -0.09261    1    1;
     11        1    1.017   -0.107    1    1;
     12        1    1.005  -0.1068    1    1;
     13        1     1.02  -0.1047    1    1;
     14        1     1.02  -0.1328    1    1;
     15        1     1.02  -0.1369    1    1;
     16        1    1.035  -0.1112    1    1;
     17        1    1.038  -0.1295    1    1;
     18        1    1.036  -0.1448    1    1;
     19        1    1.051 -0.02131    1    1;
     20        1   0.9917 -0.03857    1    1;
     21        1    1.034  -0.0712    1    1;
     22        1    1.051  0.00439    1    1;
     23        1    1.046 -0.0003089    1    1;
     24        1    1.041  -0.1099    1    1;
     25        1     1.06 -0.07643    1    1;
     26        1    1.055 -0.09763    1    1;
     27        1    1.041  -0.1323    1    1;
     28        1    1.052  -0.0365    1    1;
     29        1    1.051  0.01155    1    1;
     30        1    1.048 -0.05864    1    1;
     31        1    0.982        0    1    1;
     32        1    0.983  0.04639    1    1;
     33        1    0.997  0.06973    1    1;
     34        1    1.012  0.05203    1    1;
     35        1    1.049   0.0909    1    1;
     36        1    1.064   0.1365    1    1;
     37        1    1.028  0.04177    1    1;
     38        1    1.027   0.1347    1    1;
     39        1     1.03  -0.1734    1    1;
   ];

SW.con = [ ...
     31      100        1    0.982        0        8       -5      1.1      0.9    5.473 1 1  1;
   ];

PV.con = [ ...
  30      200        1     1.25    1.048        4     -2.5      1.1      0.9 1  1;
  32      200        1     3.25    0.983        4     -2.5      1.1      0.9 1  1;
  33      200        1     3.16    0.997        4     -2.5      1.1      0.9 1  1;
  34      100        1     5.08    1.012        8       -3      1.1      0.9 1  1;
  35      200        1     3.25    1.049        4     -2.5      1.1      0.9 1  1;
  36      200        1      2.8    1.064        4     -2.5      1.1      0.9 1  1;
  37      200        1      2.7    1.028        4     -2.5      1.1      0.9 1  1;
  38      200        1     4.15    1.027        4     -2.5      1.1      0.9 1  1;
  39     2000        1      0.5     1.03     0.75     -0.5      1.1      0.9 1  1;
   ];

PQ.con = [ ...
   3 100        1     3.22    0.024      1.1      0.9 0 1;
   4 100        1        5     1.84      1.1      0.9 0 1;
   7 100        1    2.338     0.84      1.1      0.9 0 1;
   8 100        1     5.22     1.76      1.1      0.9 0 1;
  12 100        1    0.075     0.88      1.1      0.9 0 1;
  15 100        1      3.2     1.53      1.1      0.9 0 1;
  16 100        1    3.294    0.323      1.1      0.9 0 1;
  18 100        1     1.58      0.3      1.1      0.9 0 1;
  20 100        1     6.28     1.03      1.1      0.9 0 1;
  21 100        1     2.74     1.15      1.1      0.9 0 1;
  23 100        1    2.745    0.846      1.1      0.9 0 1;
  24 100        1    3.086   -0.922      1.1      0.9 0 1;
  25 100        1     2.24    0.472      1.1      0.9 0 1;
  26 100        1     1.39     0.17      1.1      0.9 0 1;
  27 100        1     2.81    0.755      1.1      0.9 0 1;
  28 100        1     2.06    0.276      1.1      0.9 0 1;
  29 100        1    2.835    0.269      1.1      0.9 0 1;
  31 100        1    0.092    0.046      1.1      0.9 0 1;
  39 100        1    11.04      2.5      1.1      0.9 0 1;
   1 100        1        0        0      1.1      0.9 0 1;
   2 100        1        0        0      1.1      0.9 0 1;
   5 100        1        0        0      1.1      0.9 0 1;
   6 100        1        0        0      1.1      0.9 0 1;
   9 100        1        0        0      1.1      0.9 0 1;
  10 100        1        0        0      1.1      0.9 0 1;
  11 100        1        0        0      1.1      0.9 0 1;
  13 100        1        0        0      1.1      0.9 0 1;
  14 100        1        0        0      1.1      0.9 0 1;
  17 100        1        0        0      1.1      0.9 0 1;
  19 100        1        0        0      1.1      0.9 0 1;
  22 100        1        0        0      1.1      0.9 0 1;
   ];

Shunt.con = [ ...
   4 100        1 60        0        1 1;
   5 100        1 60        0        2 1;
   ];

Line.con = [ ...
   1    2 100        1 60 0         0   0.0035   0.0411   0.6987        0        0        0        0     0.01  1;
   1   39 100        1 60 0         0    0.001    0.025     0.75        0        0        0        0     0.01  1;
   2    3 100        1 60 0         0   0.0013   0.0151   0.2572        0        0        0        0     0.01  1;
   2   25 100        1 60 0         0    0.007   0.0086    0.146        0        0        0        0     0.01  1;
   3    4 100        1 60 0         0   0.0013   0.0213   0.2214        0        0        0        0     0.01  1;
   3   18 100        1 60 0         0   0.0011   0.0133   0.2138        0        0        0        0     0.01  1;
   4    5 100        1 60 0         0   0.0008   0.0128   0.1342        0        0        0        0     0.01  1;
   4   14 100        1 60 0         0   0.0008   0.0129   0.1382        0        0        0        0     0.01  1;
   5    6 100        1 60 0         0   0.0002   0.0026   0.0434        0        0        0        0     0.01  1;
   5    8 100        1 60 0         0   0.0008   0.0112   0.1476        0        0        0        0     0.01  1;
   6    7 100        1 60 0         0   0.0006   0.0092    0.113        0        0        0        0     0.01  1;
   6   11 100        1 60 0         0   0.0007   0.0082   0.1389        0        0        0        0     0.01  1;
   7    8 100        1 60 0         0   0.0004   0.0046    0.078        0        0        0        0     0.01  1;
   8    9 100        1 60 0         0   0.0023   0.0363   0.3804        0        0        0        0     0.01  1;
   9   39 100        1 60 0         0    0.001    0.025      1.2        0        0        0        0     0.01  1;
  10   11 100        1 60 0         0   0.0004   0.0043   0.0729        0        0        0        0     0.01  1;
  10   13 100        1 60 0         0   0.0004   0.0043   0.0729        0        0        0        0     0.01  1;
  13   14 100        1 60 0         0   0.0009   0.0101   0.1723        0        0        0        0     0.01  1;
  14   15 100        1 60 0         0   0.0018   0.0217    0.366        0        0        0        0     0.01  1;
  15   16 100        1 60 0         0   0.0009   0.0094    0.171        0        0        0        0     0.01  1;
  16   17 100        1 60 0         0   0.0007   0.0089   0.1342        0        0        0        0     0.01  1;
  16   19 100        1 60 0         0   0.0016   0.0195    0.304        0        0        0        0     0.01  1;
  16   21 100        1 60 0         0   0.0008   0.0135   0.2548        0        0        0        0     0.01  1;
  16   24 100        1 60 0         0   0.0003   0.0059    0.068        0        0        0        0     0.01  1;
  17   18 100        1 60 0         0   0.0007   0.0082   0.1319        0        0        0        0     0.01  1;
  17   27 100        1 60 0         0   0.0013   0.0173   0.3216        0        0        0        0     0.01  1;
  21   22 100        1 60 0         0   0.0008    0.014   0.2565        0        0        0        0     0.01  1;
  22   23 100        1 60 0         0   0.0006   0.0096   0.1846        0        0        0        0     0.01  1;
  23   24 100        1 60 0         0   0.0022    0.035    0.361        0        0        0        0     0.01  1;
  25   26 100        1 60 0         0   0.0032   0.0323    0.513        0        0        0        0     0.01  1;
  26   27 100        1 60 0         0   0.0014   0.0147   0.2396        0        0        0        0     0.01  1;
  26   28 100        1 60 0         0   0.0043   0.0474   0.7802        0        0        0        0     0.01  1;
  26   29 100        1 60 0         0   0.0057   0.0625    1.029        0        0        0        0     0.01  1;
  28   29 100        1 60 0         0   0.0014   0.0151    0.249        0        0        0        0     0.01  1;
   2   30 100        1 60 0         1        0   0.0181        0    1.025        0        0        0        0  1;
  31    6 100        1 60 0         1        0    0.025        0    0.993        0        0        0        0  1;
  10   32 100        1 60 0         1        0     0.02        0     1.07        0        0        0        0  1;
  12   11 100        1 60 0         1   0.0016   0.0435        0    1.006        0        0        0        0  1;
  12   13 100        1 60 0         1   0.0016   0.0435        0    1.006        0        0        0        0  1;
  19   20 100        1 60 0         1   0.0007   0.0138        0     1.06        0        0        0        0  1;
  19   33 100        1 60 0         1   0.0007   0.0142        0     1.07        0        0        0        0  1;
  20   34 100        1 60 0         1   0.0009    0.018        0    1.009        0        0        0        0  1;
  22   35 100        1 60 0         1        0   0.0143        0    1.025        0        0        0        0  1;
  23   36 100        1 60 0         1   0.0005   0.0272        0        1        0        0        0        0  1;
  25   37 100        1 60 0         1   0.0006   0.0232        0    1.025        0        0        0        0  1;
  29   38 100        1 60 0         1   0.0008   0.0156        0    1.025        0        0        0        0  1;
   ];

Bus.names = {...
      '1'; '2'; '3'; '4'; '5'; 
      '6'; '7'; '8'; '9'; '10'; 
      '11'; '12'; '13'; '14'; '15'; 
      '16'; '17'; '18'; '19'; '20'; 
      '21'; '22'; '23'; '24'; '25'; 
      '26'; '27'; '28'; '29'; '30'; 
      '31'; '32'; '33'; '34'; '35'; 
      '36'; '37'; '38'; '39'};

Syn.con = [ ... 
% see table 15.1 and 15.2
% Bno   Srat  Vn  fn |mdl typ   xl      ra          xd        xd'     xd''    T'd0  T''d0   xq      x'q    x''q   T'q0  T''q0   M=2H          D   Kw  Kp  gammaP  gammaQ  TAA   S(1.0)  S(1.2)
    39,  2000, 1, 60,    4,    0.003    0          0.02       0.006    1       7      0    0.019    0.008   0      0.7    0     1000.0000     0   0   0   1       1       0       0       0;    % G1
    31,  200,  1, 60,    4,    0.035    0          0.295      0.0697   1       6.56   0    0.282    0.17    0      1.5    0     60.6000       0   0   0   1       1       0       0       0;    % G2
    32,  200,  1, 60,    4,    0.0304   0          0.2495     0.0531   1       5.7    0    0.237    0.0876  0      1.5    0     71.6000       0   0   0   1       1       0       0       0;    % G3
    33,  200,  1, 60,    4,    0.0295   0          0.262      0.0436   1       5.69   0    0.258    0.166   0      1.5    0     57.2000       0   0   0   1       1       0       0       0;    % G4
    34,  200,  1, 60,    4,    0.054    0          0.67       0.132    1       5.4    0    0.62     0.166   0      0.44   0     52.0000       0   0   0   1       1       0       0       0;    % G5
    35,  200,  1, 60,    4,    0.0224   0          0.254      0.05     1       7.3    0    0.241    0.0814  0      0.4    0     69.6000       0   0   0   1       1       0       0       0;    % G6
    36,  200,  1, 60,    4,    0.0322   0          0.295      0.049    1       5.66   0    0.292    0.186   0      1.5    0     52.8000       0   0   0   1       1       0       0       0;    % G7
    37,  200,  1, 60,    4,    0.028    0          0.29       0.057    1       6.7    0    0.28     0.0911  0      0.41   0     48.6000       0   0   0   1       1       0       0       0;    % G8
    38,  200,  1, 60,    4,    0.0298   0          0.2106     0.057    1       4.79   0    0.205    0.0587  0      1.96   0     69.0000       0   0   0   1       1       0       0       0;    % G9
    30,  200,  1, 60,    4,    0.0125   0          0.1        0.031    1       10.2   0    0.069    0.008   0      0      0     84.0000       0   0   0   1       1       0       0       0;    % G10  
 ];
% AVR data
 Exc.con = [ ... 
 %genNo AVR type  VrMax     VrMin   Ka       Ta       Kf     Tf       -    Te     Tr        Ae          Be   u
 %  12     2      4.0       0.00   100      100       0.01   100     0.0   0.09  0.01         0         0 ;
   1,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   2,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   3,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   4,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   5,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   6,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   7,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   8,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   9,      2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
   10,     2,     5.0,     -5.0,   200.0,   0.015,    0.0,  1.0,     1.0,  1.0,   0.01,     0.1,       -0.1, 1;
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



% % AVR data
% Exc.con = [ ... 
% %T1 genNo AVR type  VrMax     VrMin   mu0    T1       T2     T3      T4    Te     Tr        Ae          Be
% %T2 genNo AVR type  VrMax     VrMin   Ka    Ta       Kf     Tf      -    Te     Tr        Ae          Be   u
% % 1   1         5.37     -4.3     250     1.0      0.249   0.0     0.01  0.01   0.02      0         0 ;
%   1,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   2,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   3,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   4,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   5,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   6,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   7,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   8,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   9,  2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
%   10, 2,        5.0,     -5.0,   200.0,   0.015,    10.0,  1.0,    1.0,  1.0,   0.01,     0.0006,     0.9;
% ];