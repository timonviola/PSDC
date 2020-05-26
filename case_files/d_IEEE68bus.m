% IEEE68 BUS SYSTEM 16 GENERATORS
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
% bus no.  Vbase      V0       Th0   area no.  Reg no.
   1       1      1.045     0.00  1  1;
   2       1      0.98      0.00  1  1;
   3       1      0.983     0.00  1  1;
   4       1      0.997     0.00  1  1;
   5       1      1.011     0.00  1  1;
   6       1      1.050     0.00  1  1;
   7       1      1.063     0.00  1  1;
   8       1      1.03      0.00  1  1;
   9       1      1.025     0.00  1  1;
  10       1      1.010     0.00  1  1;
  11       1      1.000     0.00  1  1;
  12       1      1.0156    0.00  1  1;
  13       1      1.011     0.00  1  1;
  14       1      1.00      0.00  1  1;
  15       1      1.000     0.00  1  1;
  16       1      1.000     0.00  1  1;
  17       1      1.00      0.00  1  1;
  18       1      1.00      0.00  1  1;
  19       1      1.00      0.00  1  1;
  20       1      1.00      0.00  1  1;
  21       1      1.00      0.00  1  1;
  22       1      1.00      0.00  1  1;
  23       1      1.00      0.00  1  1;
  24       1      1.00      0.00  1  1;
  25       1      1.00      0.00  1  1;
  26       1      1.00      0.00  1  1;
  27       1      1.00      0.00  1  1;
  28       1      1.00      0.00  1  1;
  29       1      1.00      0.00  1  1;
  30       1      1.00      0.00  1  1;
  31       1      1.00      0.00  1  1;
  32       1      1.00      0.00  1  1;
  33       1      1.00      0.00  1  1;
  34       1      1.00      0.00  1  1;
  35       1      1.00      0.00  1  1;
  36       1      1.00      0.00  1  1;
  37       1      1.00      0.00  1  1;
  38       1      1.00      0.00  1  1;
  39       1      1.00      0.00  1  1;
  40       1      1.00      0.00  1  1;
  41       1      1.00      0.00  1  1;
  42       1      1.00      0.00  1  1;
  43       1      1.00      0.00  1  1;
  44       1      1.00      0.00  1  1;
  45       1      1.00      0.00  1  1;
  46       1      1.00      0.00  1  1;
  47       1      1.00      0.00  1  1;
  48       1      1.00      0.00  1  1;
  49       1      1.00      0.00  1  1;
  50       1      1.00      0.00  1  1;
  51       1      1.00      0.00  1  1;
  52       1      1.00      0.00  1  1;
  53       1      1.00      0.00  1  1;
  54       1      1.00      0.00  1  1;
  55       1      1.00      0.00  1  1;
  56       1      1.00      0.00  1  1;
  57       1      1.00      0.00  1  1;
  58       1      1.00      0.00  1  1;
  59       1      1.00      0.00  1  1;
  60       1      1.00      0.00  1  1;
  61       1      1.00      0.00  1  1;
  62       1      1.00      0.00  1  1;
  63       1      1.00      0.00  1  1;
  64       1      1.00      0.00  1  1;
  65       1      1.00      0.00  1  1;
  66       1      1.00      0.00  1  1;
  67       1      1.00      0.00  1  1;
  68       1      1.00      0.00  1  1;
];

Line.con =[...
% Fb    Tb   S rating    V rating f[Hz]  length (0 if pu) -        r           x           b    -       -         Imax     Pmax    Smax    u(connection stat)
   01   54   100           1        60       0     0                   0    0.0181         0    1;
   02   58   100           1        60       0     0                   0    0.0250         0    1;
   03   62   100           1        60       0     0                   0    0.0200         0    1;
   04   19   100           1        60       0     0              0.0007    0.0142         0    1;
   05   20   100           1        60       0     0              0.0009    0.0180         0    1;
   06   22   100           1        60       0     0                   0    0.0143         0    1;
   07   23   100           1        60       0     0              0.0005    0.0272         0    1;
   08   25   100           1        60       0     0              0.0006    0.0232         0    1;
   09   29   100           1        60       0     0              0.0008    0.0156         0    1;
   10   31   100           1        60       0     0                   0    0.0260         0    1;
   11   32   100           1        60       0     0                   0    0.0130         0    1;
   12   36   100           1        60       0     0                   0    0.0075         0    1;
   13   17   100           1        60       0     0                   0    0.0033         0    1;
   14   41   100           1        60       0     0                   0    0.0015         0    1;
   15   42   100           1        60       0     0                   0    0.0015         0    1;
   16   18   100           1        60       0     0                   0    0.0030         0    1;
   17   36   100           1        60       0     0              0.0005    0.0045    0.3200    1;
   18   49   100           1        60       0     0              0.0076    0.1141    1.1600    1;
   18   50   100           1        60       0     0              0.0012    0.0288    2.0600    1;
   19   68   100           1        60       0     0              0.0016    0.0195    0.3040    1;
   20   19   100           1        60       0     0              0.0007    0.0138         0    1;
   21   68   100           1        60       0     0              0.0008    0.0135    0.2548    1;
   22   21   100           1        60       0     0              0.0008    0.0140    0.2565    1;
   23   22   100           1        60       0     0              0.0006    0.0096    0.1846    1;
   24   23   100           1        60       0     0              0.0022    0.0350    0.3610    1;
   24   68   100           1        60       0     0              0.0003    0.0059    0.0680    1;
   25   54   100           1        60       0     0              0.0070    0.0086    0.1460    1;
   26   25   100           1        60       0     0              0.0032    0.0323    0.5310    1;
   27   37   100           1        60       0     0              0.0013    0.0173    0.3216    1;
   27   26   100           1        60       0     0              0.0014    0.0147    0.2396    1;
   28   26   100           1        60       0     0              0.0043    0.0474    0.7802    1;
   29   26   100           1        60       0     0              0.0057    0.0625    1.0290    1;
   29   28   100           1        60       0     0              0.0014    0.0151    0.2490    1;
   30   53   100           1        60       0     0              0.0008    0.0074    0.4800    1;
   30   61   100           1        60       0     0              0.00095   0.00915   0.5800    1;
   31   30   100           1        60       0     0              0.0013    0.0187    0.3330    1;
   31   53   100           1        60       0     0              0.0016    0.0163    0.2500    1;
   32   30   100           1        60       0     0              0.0024    0.0288    0.4880    1;
   33   32   100           1        60       0     0              0.0008    0.0099    0.1680    1;
   34   33   100           1        60       0     0              0.0011    0.0157    0.2020    1;
   34   35   100           1        60       0     0              0.0001    0.0074         0    1;
   36   34   100           1        60       0     0              0.0033    0.0111    1.4500    1;
   36   61   100           1        60       0     0              0.0011    0.0098    0.6800    1;
   37   68   100           1        60       0     0              0.0007    0.0089    0.1342    1;
   38   31   100           1        60       0     0              0.0011    0.0147    0.2470    1;
   38   33   100           1        60       0     0              0.0036    0.0444    0.6930    1;
   40   41   100           1        60       0     0              0.0060    0.0840    3.1500    1;
   40   48   100           1        60       0     0              0.0020    0.0220    1.2800    1;
   41   42   100           1        60       0     0              0.0040    0.0600    2.2500    1;
   42   18   100           1        60       0     0              0.0040    0.0600    2.2500    1;
   43   17   100           1        60       0     0              0.0005    0.0276         0    1;
   44   39   100           1        60       0     0                   0    0.0411         0    1;
   44   43   100           1        60       0     0              0.0001    0.0011         0    1;
   45   35   100           1        60       0     0              0.0007    0.0175    1.3900    1;
   45   39   100           1        60       0     0                   0    0.0839         0    1;
   45   44   100           1        60       0     0              0.0025    0.0730         0    1;
   46   38   100           1        60       0     0              0.0022    0.0284    0.4300    1;
   47   53   100           1        60       0     0              0.0013    0.0188    1.3100    1;
   48   47   100           1        60       0     0              0.00125   0.0134    0.8000    1;
   49   46   100           1        60       0     0              0.0018    0.0274    0.2700    1;
   51   45   100           1        60       0     0              0.0004    0.0105    0.7200    1;
   51   50   100           1        60       0     0              0.0009    0.0221    1.6200    1;
   52   37   100           1        60       0     0              0.0007    0.0082    0.1319    1;
   52   55   100           1        60       0     0              0.0011    0.0133    0.2138    1;
   54   53   100           1        60       0     0              0.0035    0.0411    0.6987    1;
   55   54   100           1        60       0     0              0.0013    0.0151    0.2572    1;
   56   55   100           1        60       0     0              0.0013    0.0213    0.2214    1;
   57   56   100           1        60       0     0              0.0008    0.0128    0.1342    1;
   58   57   100           1        60       0     0              0.0002    0.0026    0.0434    1;
   59   58   100           1        60       0     0              0.0006    0.0092    0.1130    1;
   60   57   100           1        60       0     0              0.0008    0.0112    0.1476    1;
   60   59   100           1        60       0     0              0.0004    0.0046    0.0780    1;
   61   60   100           1        60       0     0              0.0023    0.0363    0.3804    1;
   63   58   100           1        60       0     0              0.0007    0.0082    0.1389    1;
   63   62   100           1        60       0     0              0.0004    0.0043    0.0729    1;
   63   64   100           1        60       0     0              0.0016    0.0435         0    1;
   65   62   100           1        60       0     0              0.0004    0.0043    0.0729    1;
   65   64   100           1        60       0     0              0.0016    0.0435         0    1;
   66   56   100           1        60       0     0              0.0008    0.0129    0.1382    1;
   66   65   100           1        60       0     0              0.0009    0.0101    0.1723    1;
   67   66   100           1        60       0     0              0.0018    0.0217    0.3660    1;
   68   67   100           1        60       0     0              0.0009    0.0094    0.1710    1;
   27   53   100           1        60       0     0              0.0320    0.3200    0.4100    1;
]; 

SW.con = [ ...
%bus no.    S rating    Vrating     V0      Th0     Qmax    Qmin    Vmax    Vmin    Pg0     gamma   z   u
  16        100.00        138.00    1.000  0.00     9.90    -9.90   1.1     0.9   40    1       1    1];

PV.con = [
% bus no    Srating     Vrating     Pg      V0      Qmax    Qmin    Vmax    Vmin    gamma   u   P=(1+gamma*kG)Pg
  01        100         1           2.50   1.045     1e3    -1e3     1.1     0.9      1      1       1    
  02        100         1           5.45   0.98      1e3    -1e3     1.1     0.9      1      1       1  
  03        100         1           6.50   0.983     1e3    -1e3     1.1     0.9      1      1       1    
  04        100         1           6.32   0.997     1e3    -1e3     1.1     0.9      1      1       1    
  05        100         1           5.05   1.011     1e3    -1e3     1.1     0.9      1      1       1    
  06        100         1           7.00   1.050     1e3    -1e3     1.1     0.9      1      1       1    
  07        100         1           5.60   1.063     1e3    -1e3     1.1     0.9      1      1       1    
  08        100         1           5.40   1.03      1e3    -1e3     1.1     0.9      1      1       1  
  09        100         1           8.00   1.025     1e3    -1e3     1.1     0.9      1      1       1    
  10        100         1           5.00   1.010     1e3    -1e3     1.1     0.9      1      1       1    
  11        100         1          10.000  1.000     1e3    -1e3     1.1     0.9      1      1       1    
  12        100         1          13.50   1.0156    1e3    -1e3     1.1     0.9      1      1       1    
  13        100         1          35.91   1.011     1e3    -1e3     1.1     0.9      1      1       1    
  14        100         1          17.85   1.00      1e3    -1e3     1.1     0.9      1      1       1  
  15        100         1          10.00   1.000     1e3    -1e3     1.1     0.9      1      1       1    
  16        100         1          40.00   1.000     1e3    -1e3     1.1     0.9      1      1       1    
];

PQ.con = [ ...
% bus Srating Vrating   Pl        Ql     Vmax Vmin    z   u
  17    100     1      60.00     3.00     1.1  0.9    0   1;             
  18    100     1      24.70     1.23     1.1  0.9    0   1;             
  19    100     1       0.00     0.00     1.1  0.9    0   1;             
  20    100     1       6.800    1.03     1.1  0.9    0   1;             
  21    100     1       2.740    1.15     1.1  0.9    0   1;             
  22    100     1       0.00     0.00     1.1  0.9    0   1;             
  23    100     1       2.480    0.85     1.1  0.9    0   1;             
  24    100     1       3.09    -0.92     1.1  0.9    0   1;             
  25    100     1       2.24     0.47     1.1  0.9    0   1;             
  26    100     1       1.39     0.17     1.1  0.9    0   1;             
  27    100     1       2.810    0.76     1.1  0.9    0   1;             
  28    100     1       2.060    0.28     1.1  0.9    0   1;             
  29    100     1       2.840    0.27     1.1  0.9    0   1;             
  30    100     1       0.00     0.00     1.1  0.9    0   1;             
  31    100     1       0.00     0.00     1.1  0.9    0   1;             
  32    100     1       0.00     0.00     1.1  0.9    0   1;             
  33    100     1       1.12     0.00     1.1  0.9    0   1;             
  34    100     1       0.00     0.00     1.1  0.9    0   1;             
  35    100     1       0.00     0.00     1.1  0.9    0   1;             
  36    100     1       1.02    -0.1946   1.1  0.9    0   1;               
  37    100     1       0.00     0.00     1.1  0.9    0   1;             
  38    100     1       0.00     0.00     1.1  0.9    0   1;             
  39    100     1       2.67     0.126    1.1  0.9    0   1;              
  40    100     1       0.6563   0.2353   1.1  0.9    0   1;               
  41    100     1      10.00     2.50     1.1  0.9    0   1;             
  42    100     1      11.50     2.50     1.1  0.9    0   1;             
  43    100     1       0.00     0.00     1.1  0.9    0   1;             
  44    100     1       2.6755   0.0484   1.1  0.9    0   1;               
  45    100     1       2.08     0.21     1.1  0.9    0   1;             
  46    100     1       1.507    0.285    1.1  0.9    0   1;              
  47    100     1       2.0312   0.3259   1.1  0.9    0   1;               
  48    100     1       2.4120   0.022    1.1  0.9    0   1;              
  49    100     1       1.6400   0.29     1.1  0.9    0   1;             
  50    100     1       1.00    -1.47     1.1  0.9    0   1;             
  51    100     1       3.37    -1.22     1.1  0.9    0   1;             
  52    100     1       1.58     0.30     1.1  0.9    0   1;             
  53    100     1       2.527    1.1856   1.1  0.9    0   1;               
  54    100     1       0.00     0.00     1.1  0.9    0   1;             
  55    100     1       3.22     0.02     1.1  0.9    0   1;             
  56    100     1       2.00    0.736     1.1  0.9    0   1;             
  57    100     1       0.00     0.00     1.1  0.9    0   1;             
  58    100     1       0.00     0.00     1.1  0.9    0   1;             
  59    100     1       2.34     0.84     1.1  0.9    0   1;             
  60    100     1      2.088    0.708     1.1  0.9    0   1;             
  61    100     1       1.04     1.25     1.1  0.9    0   1;             
  62    100     1       0.00     0.00     1.1  0.9    0   1;             
  63    100     1       0.00     0.00     1.1  0.9    0   1;             
  64    100     1       0.09     0.88     1.1  0.9    0   1;             
  65    100     1       0.00     0.00     1.1  0.9    0   1;             
  66    100     1       0.00     0.00     1.1  0.9    0   1;             
  67    100     1       3.200    1.5300   1.1  0.9    0   1;               
  68    100     1       3.290    0.32     1.1  0.9    0   1;               
];

Shunt.con = [ ...
% bus  Sn      Vn      PG        Qg
   1  100.00   138.00  0.00000  0.05000  1;
   2  100.00   138.00  0.00000  0.10000  1;
   3  100.00   138.00  0.00000  0.09000  1;
   4  100.00   138.00  0.00000  0.07000  1;
   5  100.00   138.00  0.00000  0.10000  1;
   6  100.00   138.00  0.00000  0.08000  1;
   7  100.00   138.00  0.00000  0.08000  1;
   8  100.00   138.00  0.00000  0.09000  1;
   9  100.00   138.00  0.00000  0.09000  1;
  10  100.00   138.00  0.00000  0.08000  1;
  11  100.00   138.00  0.00000  0.07200  1;
  12  100.00   138.00  0.00000  0.05000  1;
  13  100.00   138.00  0.00000  0.12000  1;
  14  100.00   138.00  0.00000  0.06900  1;
  15  100.00   138.00  0.00000  0.06900  1;
  16  100.00   138.00  0.00000  0.16500  1;
   4  100.00   138.00  0.00000  0.01000  1;
   ];

% Line.con = [ ...
% % From bus  To bus      S rating    V rating    f[Hz]    -           r           x           -           a           thet     Imax       Pmax     Smax    u(connection stat)
%     7       23          1.00        138.00      60       0           0.00     94299.00000    36.00000    0.00000     1.00000  0.00000     0.001    0.028    0.000  1;
%    18       49          1.00        138.00      60       0           0.00     249696.00000   50.00000    0.00000     1.00000  0.00000     0.002    0.020    0.304  1;
%    21       68          1.00        138.00      60       0           0.00     38016.00000    23.00000    0.00000     1.00000  0.00000     0.002    0.035    0.361  1;
%    25       26          1.00        138.00      60       0           0.00     54675.00000    54.00000    0.00000     1.00000  0.00000     0.001    0.015    0.240  1;
%    26       29          1.00        138.00      60       0           0.00     227529.00000   37.00000    0.00000     1.00000  0.00000     0.032    0.320    0.410  1;
%    30       31          1.00        138.00      60       0           0.00     252810.00000   32.00000    0.00000     1.00000  0.00000     0.001    0.007    0.480  1;
%    31       38          1.00        138.00      60       0           0.00     101277.00000   53.00000    0.00000     1.00000  0.00000     0.001    0.010    0.168  1;
%    33       38          1.00        138.00      60       0           0.00     206550.00000   36.00000    0.00000     1.00000  0.00000     0.001    0.018    1.390  1;
%    37       52          1.00        138.00      60       0           0.00     234876.00000   68.00000    0.00000     1.00000  0.00000     0.002    0.028    0.430  1;
%    39       45          1.00        138.00      60       0           0.00     276480.00000   41.00000    0.00000     1.00000  0.00000     0.002    0.022    1.280  1;
%    43       44          1.00        138.00      60       0           0.00     343332.00000   45.00000    0.00000     1.00000  0.00000     0.000    0.011    0.720  1;
%    47       48          1.00        138.00      60       0           0.00     366741.00000   53.00000    0.00000     1.00000  0.00000     0.001    0.022    1.620  1;
%    53       54          1.00        138.00      60       0           0.00     508032.00000   55.00000    0.00000     1.00000  0.00000     0.001    0.021    0.221  1;
%    56       66          1.00        138.00      60       0           0.00     615600.00000   58.00000    0.00000     1.00000  0.00000     0.001    0.011    0.148  1;
%    58       63          1.00        138.00      60       0           0.00     658617.00000   60.00000    0.00000     1.00000  0.00000     0.002    0.036    0.380  1;
%    62       65          1.00        138.00      60       0           0.00     875355.00000   66.00000    0.00000     1.00000  0.00000     0.002    0.022    0.366  1;
% ];

Bus.names = { ...
  '1'; '2'; '3'; '4'; '5';
  '6'; '7'; '8'; '9'; '10';
  '11'; '12'; '13'; '14'; '15';
  '16'; '17'; '18'; '19'; '20';
  '21'; '22'; '23'; '24'; '25';
  '26'; '27'; '28'; '29'; '30';
  '31'; '32'; '33'; '34'; '35';
  '36'; '37'; '38'; '39'; '40';
  '41'; '42'; '43'; '44'; '45';
  '46'; '47'; '48'; '49'; '50';
  '51'; '52'; '53'; '54'; '55';
  '56'; '57'; '58'; '59'; '60';
  '61'; '62'; '63'; '64'; '65';
  '66'; '67'; '68'};


Syn.con = [ ... 
% see table 15.1 and 15.2
% Bno   Srat  Vn  fn |mdl typ   xl      ra    xd     xd'     xd''     T'd0  T''d0  xq      x'q         x''q   T'q0  T''q0   M=2H   D   Kw  Kp  gammaP  gammaQ  TAA   S(1.0)  S(1.2)
    1   100   1   60   4       0.0125   0.0   0.1    0.031   0.025    10.2  0.05   0.069   0.0416667   0.025   1.5   0.035  84.00  0    0  0    1        1      0     0       0;  
    2   100   1   60   4       0.035    0.0   0.295  0.0697  0.05     6.56  0.05   0.282   0.0933333   0.05    1.5   0.035  60.40  0    0  0    1        1      0     0       0; 
    3   100   1   60   4       0.0304   0.0   0.2495 0.0531  0.045    5.7   0.05   0.237   0.0714286   0.045   1.5   0.035  71.60  0    0  0    1        1      0     0       0; 
    4   100   1   60   4       0.0295   0.0   0.262  0.0436  0.035    5.69  0.05   0.258   0.0585714   0.035   1.5   0.035  57.20  0    0  0    1        1      0     0       0; 
    5   100   1   60   4       0.027    0.0   0.33   0.066   0.05     5.4   0.05   0.31    0.0883333   0.05    0.44  0.035  52.00  0    0  0    1        1      0     0       0; 
    6   100   1   60   4       0.0224   0.0   0.254  0.05    0.04     7.3   0.05   0.241   0.0675000   0.04    0.4   0.035  69.60  0    0  0    1        1      0     0       0; 
    7   100   1   60   4       0.0322   0.0   0.295  0.049   0.04     5.66  0.05   0.292   0.0666667   0.04    1.5   0.035  52.80  0    0  0    1        1      0     0       0; 
    8   100   1   60   4       0.028    0.0   0.29   0.057   0.045    6.7   0.05   0.280   0.0766667   0.045   0.41  0.035  48.60  0    0  0    1        1      0     0       0; 
    9   100   1   60   4       0.0298   0.0   0.2106 0.057   0.045    4.79  0.05   0.205   0.0766667   0.045   1.96  0.035  69.00  0    0  0    1        1      0     0       0; 
    10  100   1   60   4       0.0199   0.0   0.169  0.0457  0.04     9.37  0.05   0.115   0.0615385   0.04    1.5   0.035  62.00  0    0  0    1        1      0     0       0; 
    11  100   1   60   4       0.0103   0.0   0.128  0.018   0.012    4.1   0.05   0.123   0.0241176   0.012   1.5   0.035  56.40  0    0  0    1        1      0     0       0; 
    12  100   1   60   4       0.022    0.0   0.101  0.031   0.025    7.4   0.05   0.095   0.0420000   0.025   1.5   0.035  184.60 0    0  0    1        1      0     0       0; 
    13  200   1   60   4       0.0030   0.0   0.0296 0.0055  0.004    5.9   0.05   0.0286  0.0074000   0.004   1.5   0.035  496.00 0    0  0    1        1      0     0       0; 
    14  100   1   60   4       0.0017   0.0   0.018  0.00285 0.0023   4.1   0.05   0.0173  0.0037931   0.0023  1.5   0.035  600.00 0    0  0    1        1      0     0       0; 
    15  100   1   60   4       0.0017   0.0   0.018  0.00285 0.0023   4.1   0.05   0.0173  0.0037931   0.0023  1.5   0.035  600.00 0    0  0    1        1      0     0       0; 
    16  200   1   60   4       0.0041   0.0   0.0356 0.0071  0.0055   7.8   0.05   0.0334  0.0095000   0.0055  1.5   0.035  450.00 0    0  0    1        1      0     0       0; 
];                               

Exc.con = [...
%genNo AVR type  VrMax     VrMin   Ka       Ta       Kf     Tf       -    Te     Tr        Ae         Be    u
    1      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    2      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    3      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    4      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    5      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    6      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    7      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    8      2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    9      1      5.0       -5.0   200.    0.00     0       0       1     0     0.01      0          0      1;     
    10     2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    11     2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    12     2      10.       -10.   1.      0.02     0.030   1.0     1    .785   0.01      0.070      0.910  1;
    ];
 
Pss.con = [...
%AVR num    PPS model   pss input   VMAX    VMIN        Kw    Tw  T1    T2     T3    T4      Ka Ta Kp Kv Vamax V*amax   Vs*max   Vs*min   ethr  wthr  s2 u 
    1          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;  
    2          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    3          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    4          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    5          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    6          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    7          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    8          2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    9          2            1        0.2    -0.05       12    10  0.09  0.02  0.09  0.02      1  1  1  1   1      1       1        1         1    1    1 1;
    10         2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    11         2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
    12         2            1        0.2    -0.05       20    15  0.15  0.04  0.15  0.04      1  1  1  1   1      1       1        1         1    1    1 1;
];




%% Original dynamic data
% *********************** MACHINE DATA STARTS ***************************
% Machine data format
%       1. machine number,
%       2. bus number,
%       3. base mva,
%       4. leakage reactance x_l(pu),
%       5. resistance r_a(pu),
%       6. d-axis sychronous reactance x_d(pu),
%       7. d-axis transient reactance x'_d(pu),
%       8. d-axis subtransient reactance x"_d(pu),
%       9. d-axis open-circuit time constant T'_do(sec),
%      10. d-axis open-circuit subtransient time constant
%                T"_do(sec),
%      11. q-axis sychronous reactance x_q(pu),
%      12. q-axis transient reactance x'_q(pu),
%      13. q-axis subtransient reactance x"_q(pu),
%      14. q-axis open-circuit time constant T'_qo(sec),
%      15. q-axis open circuit subtransient time constant
%                T"_qo(sec),
%      16. inertia constant H(sec),
%      17. damping coefficient d_o(pu),
%      18. dampling coefficient d_1(pu),
%      19. bus number
%      20. saturation factor S(1.0) 
%      21. saturation factor S(1.2) 
% note: all the following machines use subtransient reactance model
% mac_con = [
% % % 1  2    3   4      5   6      7       8         9    10   11     12          13       14   15    16    17 18 19  20 21  
%     01 01  100 0.0125 0.0  0.1    0.031   0.025    10.2  0.05 0.069  0.0416667   0.025   1.5   0.035 42.   0  0  01   0 0;
%     02 02  100 0.035  0.0  0.295  0.0697  0.05     6.56  0.05 0.282  0.0933333   0.05    1.5   0.035 30.2  0  0  02   0 0;
%     03 03  100 0.0304 0.0  0.2495 0.0531  0.045    5.7   0.05 0.237  0.0714286   0.045   1.5   0.035 35.8  0  0  03   0 0;
%     04 04  100 0.0295 0.0  0.262  0.0436  0.035    5.69  0.05 0.258  0.0585714   0.035   1.5   0.035 28.6  0  0  04   0 0;
%     05 05  100 0.027  0.0  0.33   0.066   0.05     5.4   0.05 0.31   0.0883333   0.05    0.44  0.035 26.   0  0  05   0 0;
%     06 06  100 0.0224 0.0  0.254  0.05    0.04     7.3   0.05 0.241  0.0675000   0.04    0.4   0.035 34.8  0  0  06   0 0;
%     07 07  100 0.0322 0.0  0.295  0.049   0.04     5.66  0.05 0.292  0.0666667   0.04    1.5   0.035 26.4  0  0  07   0 0;
%     08 08  100 0.028  0.0  0.29   0.057   0.045    6.7   0.05 0.280  0.0766667   0.045   0.41  0.035 24.3  0  0  08   0 0;
%     09 09  100 0.0298 0.0  0.2106 0.057   0.045    4.79  0.05 0.205  0.0766667   0.045   1.96  0.035 34.5  0  0  09   0 0;
%     10 10  100 0.0199 0.0  0.169  0.0457  0.04     9.37  0.05 0.115  0.0615385   0.04    1.5   0.035 31.0  0  0  10   0 0;
%     11 11  100 0.0103 0.0  0.128  0.018   0.012    4.1   0.05 0.123  0.0241176   0.012   1.5   0.035 28.2  0  0  11   0 0;
%     12 12  100 0.022  0.0  0.101  0.031   0.025    7.4   0.05 0.095  0.0420000   0.025   1.5   0.035 92.3  0  0  12   0 0;
%     13 13  200 0.0030 0.0  0.0296 0.0055  0.004    5.9   0.05 0.0286 0.0074000   0.004   1.5   0.035 248.0 0  0  13   0 0;
%     14 14  100 0.0017 0.0  0.018  0.00285 0.0023   4.1   0.05 0.0173 0.0037931   0.0023  1.5   0.035 300.0 0  0  14   0 0;
%     15 15  100 0.0017 0.0  0.018  0.00285 0.0023   4.1   0.05 0.0173 0.0037931   0.0023  1.5   0.035 300.0 0  0  15   0 0;
%     16 16  200 0.0041 0.0  0.0356 0.0071  0.0055   7.8   0.05 0.0334 0.0095000   0.0055  1.5   0.035 225.0 0  0  16   0 0;
%                             ] ;



% ************************ EXCITER DATA STARTS ************************
% Description of Exciter data starts
% exciter data DC4B,ST1A model
%     1 - exciter type (1 for DC4B -> psat type 2, 0 for ST1A -> psat type 1)
%     2 - machine number
%     3 - input filter time constant T_R
%     4 - voltage regulator gain K_A
%     5 - voltage regulator time constant T_A
%     6 - maximum voltage regulator output V_Rmax
%     7 - minimum voltage regulator output V_Rmin
%     8 - exciter constant K_E
%     9 - exciter time constant T_E
%    10 - E_1
%    11 - S(E_1) psat -> Ae
%    12 - E_2
%    13 - S(E_2) psat -> Be
%    14 - stabilizer gain K_F
%    15 - stabilizer time constant T_F
%    16 - K_P
%    17 - K_I
%    18 - K_D
%    19 - T_D
% exc_con = [...
%     - -   3   4    5    6    7     8       9    10     11    12    13    14   15   16  17 18  19
%     1 1  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 2  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 3  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 4  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 5  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 6  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 7  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 8  0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     0 9  0.01 200. 0.00 5.0  -5.0  0.0     0   0      0     0      0     0     0   0   0  0    0;
%     1 10 0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 11 0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%     1 12 0.01 1.   0.02 10.  -10.  1.0    .785 3.9267 0.070 5.2356 0.910 0.030 1.0 200 50 50 .01;
%           ];
%************************ EXCITER DATA ENDS ************************
 
% ************************ PSS DATA STARTS ************************
%1-S. No.
%2-present machine index
%3-pssgain
%4-washout time constant
%5-first lead time constant
%6-first lag time constant
%7-second lead time constant
%8-second lag time constant
%9-third lead time constant
%10-third lag time constant
%11-maximum output limit
%12-minimum output limit
% pss_con = [
% %   1   2    3   4   5     6     7     8     9     10   11   12 
%     1   1   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     2   2   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     3   3   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     4   4   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     5   5   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     6   6   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     7   7   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     8   8   20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     9   9   12  10  0.09  0.02  0.09  0.02  1     1    0.2 -0.05 ;
%     10  10  20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     11  11  20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     12  12  20  15  0.15  0.04  0.15  0.04  0.15  0.04 0.2 -0.05 ;
%     ];
%************************ PSS DATA ENDS ************************