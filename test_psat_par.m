% Script to test parallel execution of PSAT operations such as power-flow
% or eigenvalue calculations


%% Set up cluster
clust=parcluster(dccClusterProfile());    % load the default cluster profile
numw = 64;
p = parpool(clust, numw);
disp(p)

%% Voltage vector
N = 1e4;
nCol = 11;
dom = [-200 200];
spaceGrid = lhsdesign(N,nCol);
spaceGrid = spaceGrid.*diff(dom)+dom(1);

voltages = cell(N,1);
Asys = cell(N,1);

%% PSAT

% Update values
parfor i =1:N
    ps = psat('command_line_psat',true,'nosplash',true);
    % do not display opf message in cmw (e.g.: pf details)
    ps.clpsat.mesg = 0;
    % do not reload data file on pf run
    ps.clpsat.readfile = 0;

    caseName = 'd_009_dyn';
    ps.runpsat(caseName,'data');
    ps.runpsat('pf')
    ps.PV.store = spaceGrid(i,:);
    ps.runpsat('pf');
    ps.fm_abcd();
    
    voltages{i} = ps.DAE.y(1+ps.Bus.n:2*ps.Bus.n);
    Asys{i} = ps.LA.a; 
end


save([mfilename N '.mat'],'Asys','spaceGrid')
