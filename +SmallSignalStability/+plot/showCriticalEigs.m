
% Copyright (C) 2020 Timon Viola
function showCriticalEigs(ax,zeta,dr)
pms = {'Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r',...
    'MarkerFaceAlpha',0.25,'SizeData',50};
    
minZ = scatter(ax,real(p(zeta==dr)),imag(p(zeta==dr)),pms{:}); % TODO: use eigPlot
legend(minZ,['no. Critical poles: ' num2str(length(minZ.XData))],...
    'Location','northwest')

fprintf('\nCritical poles:\n')
disp(p(zeta==dr))
end