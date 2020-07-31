% Test OOPSAT eigenvalue computation.
%
% Copyright (C) 2020 Timon Viola

N = 20;
PG = 4;
PV = 5;
caseName = 'case_files/d_case68.m';

voltages = cell(N,1);       % voltages
Asys = cell(N,1);           % system matrices

ps = psat('command_line_psat',true,'nosplash',true);
% do not display opf message in cmw (e.g.: pf details)
ps.clpsat.mesg = 0;
% do not reload data file on pf run
ps.clpsat.readfile = 0;
ps.Settings.pv2pq=1;
ps.runpsat(caseName,'data');
ps.runpsat('pf')

% loadData = ps.PQ.store;
% loadData(:,PG) = loadData(:,PG).*0.5;
% ps.PQ.store = loadData;
% ps.runpsat('pf');

nPg = size(ps.PV.store,1);

% Update values
for i =1:N
    % Change generator Pg output
    generatorData = ps.PV.store;
    generatorData(:,PV) = generatorData(:,PV).*0.99;%1.05;%rand(nPg,1)*2;
    ps.PV.store = generatorData;
    
    ps.runpsat('pf');
    ps.fm_abcd();
    
    voltages{i} = ps.DAE.y(1+ps.Bus.n:2*ps.Bus.n);
    Asys{i} = ps.LA.a; 
end

warning('off','PSDC:SSS:eig')
SmallSignalStability.plot.compareEigenValues(Asys)
warning('on','PSDC:SSS:eig')
SmallSignalStability.plot.plotStabMargin(0.03);
