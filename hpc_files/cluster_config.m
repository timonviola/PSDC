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
% set que name so we don't end up in the common hpc
c.AdditionalProperties.QueueName='elektro';

% save as default profile
c.saveProfile
%% List all available profiles
[ALLPROFILES, DEFAULTPROFILE] = parallel.clusterProfiles;

%% Export profile to file
parallel.exportProfile('MyProfile','MyExportedProfileFileName')
% will be saved to current dir with .settings extension


% Set up batch script according to http://www.hpc.dtu.dk/?page_id=2021#Distrib_Run
% I saved my cluster as clusterProfileElektro2019 to
% elektroProfile.settings