% Test script that calls PSAT and other functionalities in order to verify
% the expected behaviour on a new system.
% * initialize PSAT instance    (PSAT)
% * load data                   (PSAT)
% * execute power-flow          (PSAT)
% * build system matrix A       (PSAT)
% * calculate eigen properties
% * plot
%
% Copyright (C) 2020 Timon Viola

clear

if ~ispc
    util.add_dependencies
end
%% Initilize PSAT instance
fprintf(pad('Initializing PSAT',50,'right','.'))
ps = psat('command_line_psat',true,'nosplash',true);
fprintf('SUCCESSFUL\n')

% do not display opf message in cmw (e.g.: pf details)
% ps.clpsat.mesg = 0;
% do not reload data file on pf run
ps.clpsat.readfile = 0;

%% Load case, power-flow
caseFolder = [pwd filesep 'case_files' filesep];

caseName = 'd_case9';
fprintf(pad(['Load case ' caseName],50,'right','.'))
ps.runpsat(['case_files' filesep caseName '.m'],'data');
fprintf('SUCCESSFUL\n')

fprintf(pad('Run power-flow',50,'right','.'))
ps.runpsat('pf')
fprintf('SUCCESSFUL\n')
%% Eigenvalue analysis
fprintf(pad('Build system matrix',50,'right','.'))
ps.fm_abcd();    %  A - obj.LA.a         B - obj.LA.b_avr
                 %  C - obj.LA.c_avr     D - obj.LA.d_avr
fprintf('SUCCESSFUL\n')

fprintf(pad('Calculate eigen properties',50,'right','.'))
As = ps.LA.a;
[wn, zeta, p] = SmallSignalStability.damp_(As);
fprintf('SUCCESSFUL\n')
%% plot
[~,ax] = SmallSignalStability.plot.eigPlot(p,'shed',1000);

SmallSignalStability.plot.eigPlot([0+1i;0-1i],ax,'decorators',false...
    ,'scatterParams',{'Marker','d','MarkerEdgeColor','g'});
SmallSignalStability.plot.plotStabMargin(0.03);

%% psat cmd print
ps.powerFlowResults('print')

%% N-1 analysis for all line outages
og_case_line = ps.Line.con;
L_STAT = 16;
% iterate through all lines
A_n1 = cell(ps.Line.n,1);
t= tic;
for i = 1:ps.Line.n
    % Set line status offline
    tmp = og_case_line;
    tmp(i,L_STAT) = 0;
    ps.Line.store = tmp;
    ps.runpsat('pf')
    ps.powerFlowResults('print')
    ps.fm_abcd();
    A_n1{i} = ps.LA.a;
    toc(t)
end

SmallSignalStability.plot.compareEigenValues(A_n1)