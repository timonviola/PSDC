N = 8;
caseName = 'case_files/d_IEEE68bus.m';

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


nPg = size(ps.PV.store,1);
PG = 4;
% Update values
for i =1:N
    % Change generator Pg output
    generatorData = ps.PV.store;
    generatorData(:,PG) = generatorData(:,PG).*0.95;%1.05;%rand(nPg,1)*2;
    ps.PV.store = generatorData;
    
    ps.runpsat('pf');
    ps.fm_abcd();
    
    voltages{i} = ps.DAE.y(1+ps.Bus.n:2*ps.Bus.n);
    Asys{i} = ps.LA.a; 
end

SmallSignalStability.plot.compareEigenValues(Asys)