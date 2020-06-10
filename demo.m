%% OOPSAT


%% Julia




%% PSDC 
% 
% * Step 1: bound tightening x2, QCRM, polytope sampling
% 
edit m1
% load case
% run cheap bt
% run QCACOPF - polytope sampling
m1

% Copy the results to hpc with bash script or system if SSH keys are set
unixP = strrep(OUT_DIR,'\','/');
%%
prompt = 'Create dir on HPC? Y/N [Y]: ';
str = input(prompt,'s');
if isempty(str) || strcmpi(str,'y')
    eval(['!ssh s182215@login.gbar.dtu.dk "mkdir ' ...
        '~/thesis/PSDC/' strrep(OUT_DIR,'\','/') '"']);
end

prompt = ['Copy ' FILE_NAME_SAMPLES ' to HPC? Y/N [Y]: '];
str = input(prompt,'s');
if isempty(str) || strcmpi(str,'y')
    eval(['!scp ' unixP '/' FILE_NAME_SAMPLES...
        ' s182215@login.gbar.dtu.dk:thesis/PSDC/' unixP '/' ...
        FILE_NAME_SAMPLES])
end

% * Step 2: run modified ACOPFs
% submit julia job to run ACOPFs in parallel
edit m2_genSh.m
m2_genSh

prompt = 'Copy parallel opf job script to HPC? Y/N [Y]: ';
str = input(prompt,'s');
if isempty(str) || strcmpi(str,'y')
    eval(['!scp ' unixP '/j_opf.sh s182215@login.gbar.dtu.dk:thesis/PSDC/'...
        unixP '/'])
end

% prompt = 'Submit opf job script to HPC? Y/N [Y]: ';
% str = input(prompt,'s');
% if isempty(str) || strcmpi(str,'y')
%     eval(['!ssh s182215@login.gbar.dtu.dk "bsub < ' ...
%           'thesis/PSDC/' unixP '/' ' j_opf.sh'])
% end
fprintf('\nThe rest is through HPC. Lucky you!\n')
pause

edit m3_dw m4
% ----- HPC -----
% ssh to hpc
%bash scp_f.sh
%bsub < ____

% submit job to HPC at PSDC/

% start directed walks -> m3_dw
%bsub < run_dw.sh

% run a summary of the data set
% run_sum.m
%bsub < runSum.sh

% fit multivariate distribution and draw samples
% m4.m
% ????

% start overall evaluation


% data set ready



%% structure of main framework
help +util
help +test
help +DirectedWalks