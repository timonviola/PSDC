
load hpc_speed_test.mat % load execTime

numw = [2.^(0:(length(execTime)-1))];

figure
ax = axes;
sc = scatter(numw,execTime);

ax.XAxis.Scale = 'log';
ax.YAxis.Scale = 'log';
ax.XGrid = 'on';
ax.YMinorGrid = 'on';
ax.YGrid = 'on';
ax.XTick = numw;
title('DTU HPC MATLAB speed test')
ylabel('time [s]')
xlabel('no. workers')

