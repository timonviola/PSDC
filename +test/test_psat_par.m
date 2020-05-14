% Script to test parallel execution of PSAT operations such as power-flow
% or eigenvalue calculations

util.add_dependencies % add PSAT and MATPOWER to path

%% Set up cluster
clust=parcluster(dccClusterProfile());    % load the default cluster profile
numw = 100;
p = parpool(clust, numw);
disp(p)

if ispc
    p.addAttachedFiles('c:\Users\Timon\myPSAT\psat\');
else
    p.addAttachedFiles('~/thesis/psat/');
end
p.addAttachedFiles([pwd filesep 'd_009_dyn.m']);

%% Pre-allocate
N = 1e6;
nCol = 11;
dom = [-200 200];
spaceGrid = lhsdesign(N,nCol);
spaceGrid = spaceGrid.*diff(dom)+dom(1);    % Generator set points

voltages = cell(N,1);       % voltages
Asys = cell(N,1);           % system matrices

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
    ps.PV.store = spaceGrid(i,:); % Change generator Pg output
    ps.runpsat('pf');
    ps.fm_abcd();
    
    voltages{i} = ps.DAE.y(1+ps.Bus.n:2*ps.Bus.n);
    Asys{i} = ps.LA.a; 
end

fprintf('Saving file to: %s\n',pwd) 
fprintf('Saving file: %s\n',[mfilename strrep(sprintf('%.2g',N),'+','') '.mat'])
save([mfilename strrep(sprintf('%.2g',N),'+','') '.mat'],'Asys','spaceGrid')
