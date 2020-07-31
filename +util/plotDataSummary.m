% PLOTDATASUMMARY Create data summary plot.
% TODO: it will be interesting to see how well these points cover the
% feasible space OR/AND the n-dim unit cube.
% TODO: what is the minimum/average/maximum distance of OPs

% Most of this script is written for N-1 analysis which means that the
% structure of classDetails is 1 level deeper.
%

% Copyright (C) 2020 Timon Viola
function plotDataSummary(setPointsFile, summaryFile)
if nargin < 2
    [setPointsFile,path] = uigetfile('*.csv','Select set points file.');
    setPointsFile = fullfile(path,setPointsFile);
    [summaryFile,path] = uigetfile('*.mat','Select summary file.');
    summaryFile = fullfile(path,summaryFile);
end
% C:\Users\Timon\OneDrive - Danmarks Tekniske Universitet\Denmark\DTU\2019_20_II\software\
setpoints =  readmatrix(setPointsFile,"Delimiter",",");

% explicitly define the varialbles loaded is good practice
load(summaryFile,'stable','classDetails','dampingRatio') %#ok

% setpoints = readmatrix(".data\case9_2020_06_08T144804Z\unified_case9.csv","Delimiter",",");
% load('.data\case9_2020_06_08T144804Z\unified_case9_summary.mat')



genReport = false;

idxStablePoints = (stable == 1);

fprintf('Number of stable points: %d\n',sum(idxStablePoints))
fprintf('Dataset ratio:\t \t %4.3f%%\n',100 * sum(idxStablePoints)/length(idxStablePoints))
[stablePointNo,~] = find(idxStablePoints);



n = length(classDetails);
% x = 1:n;
y = nan(n,1);
for i = 1:n
%     y(i) = sum(sum(classDetails{i}(:,1:5)));
    y(i) = sum(classDetails{i,:});
end


%% which points are close to feasible - P set sum
FEASIBLE = 5;
x_sp = nan(n,1);
for i = 1:n
    % TODO: the voltages are also summed - mbe this should change
    x_sp(i) = sum(setpoints(i,:));
end

fig = figure('Name','Distance from feasibility [setpoints]');
ax1 = axes(fig,'Position',[.1 .15 .9 .7]);
hold on
% title('N-1 feasability vs setpoint sum')
title('Data set summary')
scatter(ax1,x_sp,y,5,y,'LineWidth',1.5) %{:}(:,1:5))
colormap(winter(max(y)))
cb = colorbar;
plot(gca,ax1.XLim,[FEASIBLE,FEASIBLE],'color',[0.64,0.08,0.18],'LineStyle','-','LineWidth',1)
text(mean(ax1.XLim),ax1.YLim(2)+2,'Feasibility','color','k')
ylim([ax1.YLim(1)-10,ax1.YLim(2)+10])
% xlabel('Sum P_{G2-G5}')
xlabel('Sum Pg Vg')
yl = ylabel('Distance from feasibility');
ax1.XGrid = 'on';
ax1.YGrid = 'on';
t1 = text(ax1.XLim(1)+5,ax1.YLim(1)+7,['no. stable points: ',num2str(sum(idxStablePoints))]);
t2 = text(ax1.XLim(1)+5,ax1.YLim(1)+3,['Dataset ratio:      ',num2str(100 * sum(idxStablePoints)/length(idxStablePoints)),'%']);


ax2 = axes(fig,'Position',[0.1,ax1.Position(2)+ax1.Position(4),ax1.Position(3),0.1]);%,GRoup,GCount,'Position',[.7 .7 .2 .2]);
% bin the data into 30 groups
[GCount,GRoup]=groupcounts(x_sp,30);
bh=bar(ax2,GRoup,GCount);
% bh = histogram(ax2,setpoints,10);
ax2.XAxis.Visible = 'off';
ax2.YAxis.Visible = 'off';
bh.EdgeColor = 'b';
bh.BaseLine.Visible = 'off';
try
    linkaxes([ax1 ax2],'x')
catch
    warning('PSDC:utils','Could not link axes')
    
end
t = title('N-1 feasibility vs. setpoint sum');
%t.Position = 1.0e+04 * [0.0131,4.3878,0];
t.FontSize = 12;

fig.Position = [398 286 426 364];
cb.Position = [0.8903 0.1500 0.0427 0.5963];
ax1.Position = [0.1000 0.1500 0.7719 0.6988];
yl.Position = [-13.3537   82.5000   -1.0000];


util.printDataSummary(stable,classDetails)

% Note: To export the figure in proper quality go to File>Export Setup>Load
% > and load myDataSet profile. This profile was set up for this figure.

% %% Wich stability check fail how many times
% constraintTypes = {'P','Q','V','S','SSS'};
% nCont = length(classDetails{1});
% checks = zeros(1,5);
% for i = 1:n
%     checks = checks + sum(classDetails{i}(:,1:5));
% end
% figure('Name','AC opf and sss constraints')
% axes;
% bar(checks);
% hold on
% title({'Constraint feasibility by type'; ['Max= ',num2str(nCont*n)]})
% ylabel('no. success')
% xlabel('type')
% plot(gca,[0,6],[nCont*n,nCont*n],'r:','LineWidth',2)
% set(gca,'xticklabel', constraintTypes)
% 
% %% Where do we have high/low feasability checks
% colors={[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],...
%     [0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880]};
% figure('Name','Constraint feasability in eventspace')
% constraintPass = zeros(n,5);
% for i = 1:n
%     constraintPass(i,:) = sum(classDetails{i}(:,1:5));
% end
% constraintPass = constraintPass/nCont; % normalization
% axes;
% hold on
% opt = {'filled','MarkerFaceAlpha',.5};
% for i = 1:5
%     subplot(2,3,i)
%     scatter(x,constraintPass(:,i),15,colors{i},opt{:},'DisplayName',constraintTypes{i});
%     hold on
%     plot([x(1) x(end)],[1,1],'r:','LineWidth',2)
%     title(constraintTypes{i})
%     %     scatter(x,constraintPass(:,2),opt{:})
% %     scatter(x,constraintPass(:,3),opt{:})
% %     scatter(x,constraintPass(:,4),opt{:})
% %     scatter(x,constraintPass(:,5),opt{:})
%     ylim([-0.1 1.1])
% end
% 
% 
% figure('Name','Constraint feasability all')
% axes;
% hold on;
% scatter(x,constraintPass(:,1),opt{:});
% scatter(x,constraintPass(:,2),opt{:})
% scatter(x,constraintPass(:,3),opt{:})
% scatter(x,constraintPass(:,4),opt{:})
% scatter(x,constraintPass(:,5),opt{:})
% ylim([-0.1 1.1])
% 
% legend(constraintTypes,'Location','southoutside','NumColumns',5,'box','on')
% 
% %% contingency failure
% figure('Name', 'Contingency failure')
% branchNo = classDetails{1,1}(:,end)';
% noContSuccess = zeros(1,nCont);
% for i = 1:n
%    noContSuccess = noContSuccess + all(classDetails{i}(:,1:5)');
% end
% 
% bar(noContSuccess)
% title('contingency failures by branch')
% ylabel('number of passes')
% xlabel('branch')
% try
%    
%    % disp('falling back to default mpc: util.case14_wind')
%     branch = ["intact", string(classDetails{1}(2:end,end)')];
% catch
%     branch = repmat('-',nCont,1);
% end
% set(gca,'xtick',1:nCont)
% set(gca,'xticklabel',branch)
% 
% set(gca,'XTickLabelRotation',45) 
% %% ----- damping ratio -----
% if exist('dampingRatio','var')
%     figure('Name','Damping ratio');
%     axes;
%     hold on
%     scatter(x,dampingRatio,5,c)
%     plot(gca,[100,n],[0.03,0.03],'color','#EDB120','LineStyle',':','LineWidth',2)
%     text(n/2,0.04,'Feasibility','color','k')
%     %ylim([50,100])
%     xlabel('Data index')
%     ylabel('Distance from feasibility')
%     dr = dampingRatio(idxStablePoints);
%     fprintf('Damping ratios:\n')
%     disp(dr(1:10))
% end
% 
% %% ----- generate report -----
% if genReport
%     prompt = 'Report title: ';
%     str = input(prompt,'s');
% if isempty(str)
%     str = "test_dataset-[" + string(datestr(now)) + "]";
% end
%     report.title = str;
%     report.fName = str;
%     report.subTitle = str;
%     util.pptgen(report)
%     
% end