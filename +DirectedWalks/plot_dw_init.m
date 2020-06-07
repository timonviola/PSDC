f = figure('WindowStyle','docked');
ax = axes;
hold on
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';
ylabel('iteration')
xlabel('damping ratio')
ax.XGrid = 'on';
ax.XMinorGrid = 'on';
drLim = xline(0.03,':','linewidth',1.5,'color','#ff9800');
ax.XLim = [-0.10 0.10];
hicU = xline(0.0325,':','linewidth',1.5,'color','#ffc107');
hicL = xline(0.0275,':','linewidth',1.5,'color','#ffc107');

prop = {'Color', [1 0 0],'LineStyle','none','Marker','o','MarkerSize',5,...
    'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0]};