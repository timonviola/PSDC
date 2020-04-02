% MATLAB DCC HPC SERVER CONFIGURATION
% Reference: https://www.hpc.dtu.dk/?page_id=2939 - 
%       MATLAB Parallel Server configuration on the LSF clusters

% lits information
configCluster

% Settings according to reference page
c = parcluster(dccClusterProfile());
% Set e-mail address
c.AdditionalProperties.EmailAddress = '182215@student.dtu.dk';
% Memory usage
c.AdditionalProperties.MemUsage = '2GB';
% Specify 8 procs per node (i.e. 8 Workers) 
c.AdditionalProperties.ProcsPerNode = 8;
% Specify the walltime (e.g. 5 hours)
c.AdditionalProperties.WallTime = '05:00';

% save as default profile
c.saveProfile
% List all available profiles
[ALLPROFILES, DEFAULTPROFILE] = parallel.clusterProfiles;

% Set up batch script according to http://www.hpc.dtu.dk/?page_id=2021#Distrib_Run