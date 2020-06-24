function varargout = eigPlot(lambda,varargin)
% EIGPLOT Plot the eigenvalues on the ImRe plane

p = inputParser;
p.KeepUnmatched = true;

defaultAxes = gca;
defaultDecorators = true;
defaultScatterParams = {};
defaultShed = 0;

validAxes = @(x) isa(x,'matlab.graphics.axis.Axes');
validEigs = @(x) isvector(x) && isnumeric(x);

addRequired(p,'lambda',validEigs)
addOptional(p,'axh',defaultAxes,validAxes)
addParameter(p,'decorators',defaultDecorators,@islogical)
addParameter(p,'scatterParams',defaultScatterParams,@iscell)
addParameter(p,'shed',defaultShed,@isnumeric)

parse(p,lambda,varargin{:});

if ~isempty(fieldnames(p.Unmatched))
   disp('Extra inputs:')
   disp(p.Unmatched)
end
if ~isempty(p.UsingDefaults)
   disp('Using defaults: ')
   disp(p.UsingDefaults)
end

lambda = p.Results.lambda;
axh = p.Results.axh;
decorators = p.Results.decorators;
scatterParams = p.Results.scatterParams;
shed = p.Results.shed;
% ===== old =====
if shed    % shed values >= limit
   idx = abs(real(lambda)) >= shed-1;
   lambda = lambda(~idx);
   fprintf('Discarded %d values.\n',sum(idx))
end

hold on
if(decorators)
% apply plot settings
    box on
    title('Eigenvalue analisys')
    xlabel('Real Axis')
    ylabel('Imginary Axis')
end
defaultAxesStyle = {'LineStyle',':',...
    'Color','0.65,0.65,0.65',...
    'HandleVisibility','off',... % hide it from user
    'HitTest','off','PickableParts','none'}; % can't click on it so its easier to click on eigenvalues
l.x = yline(0,defaultAxesStyle{:});
l.y = xline(0,defaultAxesStyle{:});


if(class(lambda) == "double")
    sh = scatter(real(lambda),imag(lambda),scatterParams{:});
elseif(class(lambda) == "cell")
    sh{:};
end

% add DR data tip row
row = dataTipTextRow('DR',-1*real(lambda)./abs(lambda),'%+4.4g');
sh.DataTipTemplate.DataTipRows(end+1) = row;

if nargout
    varargout{1} = sh;
    varargout{2} = axh;
    varargout{3} = l;
end