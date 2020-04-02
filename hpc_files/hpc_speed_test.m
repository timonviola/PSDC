% Test the actual number of cores/workes running on the HPC cluster while
% executing a parallelised script.
%   REFERENCES: 
%   + https://se.mathworks.com/help/parallel-computing/scale-up-parfor-loops-to-cluster-and-cloud.html
%   + https://www.hpc.dtu.dk/?page_id=1416 - Batch Jobs under LSF 10
%   + https://www.hpc.dtu.dk/?page_id=2021 - MATLAB Jobs under LSF
%   + https://www.hpc.dtu.dk/?page_id=2939 - MATLAB Parallel Server configuration on the LSF clusters

clust=parcluster(dccClusterProfile());    % load the default cluster profile
%numw=32;    % Exactly the number of nodes times the number of processors per cores requested

SEIG = 1e3;

%p = parpool(clust, numw) %#ok
%disp(p)                     % log the actual state of the pool

execTime = nan(7,1);

% single worker
numw = 1;
p = parpool(clust, numw) %#ok
disp(p)
execTime(1) = hpc_eig_test(SEIG);
delete(p)

% 2 workers
numw = 2;
p = parpool(clust, numw) %#ok
disp(p)
execTime(2) = hpc_eig_test(SEIG);
delete(p)

% 4 workers
numw = 4;
p = parpool(clust, numw) %#ok
disp(p)
execTime(3) = hpc_eig_test(SEIG);
delete(p)

% 8 workers
numw = 8;
p = parpool(clust, numw) %#ok
disp(p)
execTime(4) = hpc_eig_test(SEIG);
delete(p)

% 16 workers
numw = 16;
p = parpool(clust, numw) %#ok
disp(p)
execTime(5) = hpc_eig_test(SEIG);
delete(p)

% 32 workers
numw = 32;
p = parpool(clust, numw) %#ok
disp(p)
execTime(6) = hpc_eig_test(SEIG);
delete(p)

% 64 workers
numw = 64;
p = parpool(clust, numw) %#ok
disp(p)
execTime(7) = hpc_eig_test(SEIG);
delete(p)

save([mfilename '.mat'],'execTime')

