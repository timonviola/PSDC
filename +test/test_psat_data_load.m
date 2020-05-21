psr = psat('command_line_psat',true,'nosplash',true);
psr.runpsat('d_009_dyn.m','case_files\','data')
psr.runpsat('pf')
psr.powerFlowResults('print')
psr.fm_abcd()
[st,md] = SmallSignalStability.checkSmallSignalStability(0.03,psr.LA.a);





% psr = psat('command_line_psat',true,'nosplash',true);
% psr.runpsat('case_files\d_009_dyn.m','data')
% psr.runpsat('pf')