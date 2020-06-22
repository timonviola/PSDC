function varargout = compareEigenValues(A_matrices)
% COMPAREEIGENVALUES(A{}) interactive explorer of eigenvalue evolution

fh = figure;
ah = axes;

hold on
box on
title('Eigenvalue analisys')
xlabel('Real Axis')
ylabel('Imginary Axis')

defaultAxesStyle = {'LineStyle',':','Color','0.65,0.65,0.65'};
l.x = yline(0,defaultAxesStyle{:});
l.y = xline(0,defaultAxesStyle{:});

N = max(size(A_matrices));

sh = cell(N,1);
%cmp = colormap('winter');
cmp = colormap('parula');
%cmp = [cmp(1:20,:);cmp(44:end,:)];
nStp = floor(size(cmp,1)/length(sh));
cmp = cmp(1:nStp:end,:);

for i = 1:N
    [~,~,p] = SmallSignalStability.damp_(A_matrices{i});
    sh{i} = scatter(real(p),imag(p),'Visible','off','CData',cmp(i,:)); % TODO: use eigPlot
end
sh{1}.Visible = 'on';
legend([sh{:}],string(1:N),'Location','best','NumColumns',2)
ah.XLim = [-1200 200];
ah.YLim = [-15 15];

% Slider definition
% Toggle between data
sliderX = uicontrol('Style','Slider', 'Callback',@showData, ...
   'Units','normalized', 'Position',[0.94 0.05 0.03 0.8], ...
   'Min',1, 'Max',N, 'Value',1,'SliderStep',[1/N 1/N],'Tag','Ps');
dText = uicontrol('Style','text','String','-',...
    'Units','normalized', 'Position',[0.1429 0.1262 0.3021 0.0714],'Tag','dText');

[~,zeta,~] = SmallSignalStability.damp_(A_matrices{1});
dText.String = "Damping ratio: " + max(zeta);
      
oldVal = 0; 
curVal = 1;
oldColor = [0 0 0];

% Nested functions for slider control
function showData(varargin)      
      % Get current position of slider
      newVal = round(varargin{1}.Value);
      %fprintf('in: %3.3f\trounded: %d \n',varargin{1}.Value,newVal)
      varargin{1}.Value = newVal;       % bound it
      [~,zeta,~] = SmallSignalStability.damp_(A_matrices{newVal});
      chr = fprintf('Current Damping ratio: %06.4f\n',min(zeta));
      dText.String = "Damping ratio: " + min(zeta);
      if strcmp(varargin{1}.Tag,'Ps')
          %sh{curVal}.Visible = 'off';
          if(oldVal ~= 0)
            sh{oldVal}.CData = oldColor;
            sh{oldVal}.Marker = 'o';
            sh{oldVal}.Visible = 'off';
          end
          oldColor = sh{curVal}.CData;
          sh{curVal}.CData = [0.6 0.6 0.6];
          sh{curVal}.Marker = 'x';
          sh{newVal}.Visible = 'on';
      else
          error('slider:Clb','SliderCallbackError')
      end
      oldVal = curVal;
      curVal = newVal;
      drawnow                          % refresh figure
end

if 0 < nargout
    varargout{1} = ah;
end
end
