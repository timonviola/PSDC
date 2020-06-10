% OOPSAT test script
% test the following:
%   * OOPSAT launch
%   * OOPSAT file load
%   * OOPSAT power flow
%   * OOPSAT power flow result getter
%   * DirectedWalks opf limits check
clear
if ~ispc
    util.add_dependencies
end
%% OOPSAT INITIALIZATION
ps = psat('command_line_psat',true,'nosplash',true);
%% OOPSAT FILE LOAD
caseFolder = [pwd filesep 'case_files' filesep];
caseName = 'd_009_dyn';
ps.runpsat(['case_files' filesep caseName '.m'],'data');
%% OOPSAT POWER FLOW
ps.runpsat('pf')
%% OOPSAT POWER FLOW RESULTS
res = ps.powerFlowResults('print');
%% DirectedWalks CHECK OPF LIMITS
matpowerCase = loadcase([pwd filesep 'case_files' filesep 'case9.m']);
DirectedWalks.checkOPFLimits(matpowerCase,res,'print')