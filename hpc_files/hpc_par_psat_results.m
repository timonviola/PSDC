% Results of PSAT parallel run on HPC for 1e2 - 1e5 cases
% 1e2-5 number of A matrix builds from random power dispatch on HPC with a
% analyze the performance of running psat parallel on cluster
timeFormat = 'HH:MM:SS';
format = @(x) datenum(x,timeFormat);
jobDuration = @(x) datestr(diff(x),timeFormat);

% 1e2
t_n(1,1) = format('11:37:40');
t_n(2,1) = format('11:39:55'); % data_set_6148049.out
%     CPU time :                                   60.00 sec.
%     Max Memory :                                 833 MB
%     Average Memory :                             681.43 MB
%     Total Requested Memory :                     196608.00 MB
%     Delta Memory :                               195775.00 MB
%     Max Swap :                                   -
%     Max Processes :                              5
%     Max Threads :                                100
%     Run time :                                   135 sec.
%     Turnaround time :                            137 sec.

% 1e3
t_n(1,2) = format('11:41:32');
t_n(2,2) = format('11:44:13'); % data_set_6148060.out
%     CPU time :                                   62.00 sec.
%     Max Memory :                                 832 MB
%     Average Memory :                             720.50 MB
%     Total Requested Memory :                     196608.00 MB
%     Delta Memory :                               195776.00 MB
%     Max Swap :                                   -
%     Max Processes :                              5
%     Max Threads :                                100
%     Run time :                                   161 sec.
%     Turnaround time :                            162 sec.

% 1e4
t_n(1,3) = format('10:37:25');
t_n(2,3) = format('10:46:21'); % data_set_6148003.out
% Resource usage summary:
% 
%     CPU time :                                   73.16 sec.
%     Max Memory :                                 885 MB
%     Average Memory :                             791.15 MB
%     Total Requested Memory :                     196608.00 MB
%     Delta Memory :                               195723.00 MB
%     Max Swap :                                   -
%     Max Processes :                              5
%     Max Threads :                                100
%     Run time :                                   536 sec.
%     Turnaround time :                            537 sec.

% 1e5
t_n(1,4) = format('12:06:33');
t_n(2,4) = format('13:26:42'); % out_dataSet_6148200.txt
%     CPU time :                                   797.00 sec.
%     Max Memory :                                 1461 MB
%     Average Memory :                             1011.22 MB
%     Total Requested Memory :                     196608.00 MB
%     Delta Memory :                               195147.00 MB
%     Max Swap :                                   -
%     Max Processes :                              5
%     Max Threads :                                100
%     Run time :                                   4809 sec.
%     Turnaround time :                            4810 sec.

%% plot
n =  size(t_n,2);

jobD = jobDuration(t_n(:,1:n));

f = figure('Position',[403   246   560   256]);
ax = axes;
% set(f, 'MenuBar', 'none');
% set(f, 'ToolBar', 'none');
x = diff(t_n(:,1:n));
y = 10.^(2:5);
h = plot(x,y,'LineStyle','none','Marker','o','MarkerSize',5,...
    'MarkerFaceColor',[0.64 0.73 1.00],'MarkerEdgeColor',[.5 .5 .5],...
    'DisplayName',['HPC execution' newline '64 workers']);
title('PSAT parallel execution')
datetick('x',timeFormat)
ax.YScale = 'log';
ax.YAxis.Limits = [5 1.2*1e5];
ax.YGrid = 'on';
legend('Location','southeast')
xlabel('Duration')
ylabel('Number of points')
ax.TickDir = 'out';
hold on 
%
% limits 1e2 - 1e5
vx = linspace(1e2,1e5,100);
vy = interp1(y,x,vx,'linear');
plot(vy,vx,':.','DisplayName','linear interpolation')

