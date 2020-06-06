clear
if ~ispc
    util.add_dependencies
end
%% Load case, power-flow
ps = psat('command_line_psat',true,'nosplash',true);
caseFolder = [pwd filesep 'case_files' filesep];
caseName = 'd_009_dyn';
ps.runpsat(['case_files' filesep caseName '.m'],'data');
ps.runpsat('pf')
res = ps.powerFlowResults('print');

%% Check opf limits
matpowerCase = loadcase([pwd filesep 'case_files' filesep 'case9.m']);
DirectedWalks.checkOPFLimits(matpowerCase,res,'print')