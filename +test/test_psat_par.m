% Script to test parallel execution of PSAT operations such as power-flow
% or eigenvalue calculations
%
% Copyright (C) 2020 Timon Viola

util.add_dependencies % add PSAT and MATPOWER to path

%% Set up cluster
if ispc
    if isempty(gcp)
        p = parpool('nocreate');
    else
        p = gcp();
    end
else
    clust=parcluster(dccClusterProfile());    % load the default cluster profile
    numw = 100;
    p = parpool(clust, numw);
end
disp(p)

if ispc
    p.addAttachedFiles('c:\Users\Timon\myPSAT\psat\');
else
    p.addAttachedFiles('~/thesis/psat/');
end
p.addAttachedFiles([pwd filesep 'case_files' filesep 'd_009_dyn.m']);

%% Pre-allocate
N = 100;


voltages = cell(N,1);       % voltages
Asys = cell(N,1);           % system matrices

%% PSAT
PG = 4;
% Update values
parfor i =1:N
    ps = psat('command_line_psat',true,'nosplash',true);
    % do not display opf message in cmw (e.g.: pf details)
    ps.clpsat.mesg = 0;
    % do not reload data file on pf run
    ps.clpsat.readfile = 0;
    ps.Settings.pv2pq=1;
    caseName = 'case_files/d_009_dyn.m';
    ps.runpsat(caseName,'data');
    ps.runpsat('pf')
     % Change generator Pg output
    nPg = size(ps.PV.store,1);
    generatorData = ps.PV.store;
    generatorData(:,PG) = rand(nPg,1)*2;
    ps.PV.store = generatorData;
    
    ps.runpsat('pf');
    ps.fm_abcd();
    
    voltages{i} = ps.DAE.y(1+ps.Bus.n:2*ps.Bus.n);
    Asys{i} = ps.LA.a; 
end

fprintf('Saving file to: %s\n',pwd) 
fprintf('Saving file: %s\n',[mfilename strrep(sprintf('%.2g',N),'+','') '.mat'])
fName = [mfilename strrep(sprintf('%.2g',N),'+','') '.mat'];
save(fName,'Asys','voltages')

assert(isfile(fName))