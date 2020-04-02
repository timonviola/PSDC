% Test script that calls several dependencies of the package including PSAT
% and other utility functions. The main functions in the script are:
%   * load data file
%   * execute load-flow (PSAT)
%   * build system matrix A (PSAT)
%   * execute eigen value analysis
%   * plot data

clear
util.add_dependencies                           % Add PSAT,MATPOWER to path
fprintf(pad('Initializing PSAT',50,'right','.'))
util.psatSilent                            % start PSAT, spam the workspace
fprintf('SUCCESSFUL\n')
%% Load case, power-flow

caseName = 'd_009_dyn'; % PSAT can not find the files in ./case_files 
%    TODO: create temporary copy in current dir, on cleanup delete the temp file
fprintf(pad(['Load case ' caseName],50,'right','.'))

runpsat(caseName,'data')                        % load data

fprintf('SUCCESSFUL\n')
fprintf(pad('Run power-flow',50,'right','.'))
runpsat('pf')                                   % run power-flow
fprintf('SUCCESSFUL\n')
%%  A matrix, eigen values
fprintf(pad('Retrieve system matrix',50,'right','.'))

As = SmallSignalStability.getAsys;              % build system matrix
fprintf('SUCCESSFUL\n')
fprintf(pad('Calculate damping ratios',50,'right','.'))
[wn, zeta, p] = SmallSignalStability.damp_(As); % eigen value analysis
fprintf('SUCCESSFUL\n')
%% plot
[~,ax] = SmallSignalStability.plot.eigPlot(p,'shed',1000);

SmallSignalStability.plot.eigPlot([0+1i;0-1i],ax,'decorators',false...
    ,'scatterParams',{'Marker','d','MarkerEdgeColor','g'});
SmallSignalStability.plot.plotStabMargin(0.03);
%
