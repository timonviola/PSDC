% DATASUMMARY Checks all setpoints defined and saves the results.
%
% DATASUMMARY(setPointsCsv,psatFile,mpFile,varargin) Checks all setpoints
% defined by setPointsCsv agains ACOPF and Small-signal stability criteria.
% psatFile defines the dynamic data file and mpFile is the static data
% file. After the checks are finished the results are saved into a .mat
% file and the results are printed to STDOUT.
%
% See also UTIL.PRINTDATASUMMARY 

function dataSummary(setPointsCsv,psatFile,mpFile,varargin)
t = tic;
readTVars = false;
if nargin > 3
    readTVars = varargin{1};
end

if ~readTVars && (contains(setPointsCsv,'ACOPF') || contains(setPointsCsv,'QCRM'))
    warning('PSDC:utils','Input table columns will not be sorted.')
end
% columns are sorted already
% variable names should be sorted if QCRM or ACOPF data is checked, if DW
% data is checked, there is no header.
res = readtable(setPointsCsv, 'ReadVariableNames',readTVars);

% if setPointsCsv is QCRM/ACOPF the columns have to be sorted
if readTVars
    res = res(:,sort(res.Properties.VariableNames));
end

% Check for repeated data
[C, ~, ~]= unique(res,'stable');

if size(C) == size(res)
    warning('some values are doubled')
else
    fprintf('No duplicate values.\n')
end

toc(t)

N = size(res,1);
stable = nan(N,1);
% criteria fail/pass details [PG QG VM S_{flow}]
classDetails = cell(N,1);
% damping ratios (stored separately for easier access)
dampingRatio = nan(N,1);


% Set up cluster
if ispc
    if isempty(gcp)
        p = parpool('nocreate');
    else
        p = gcp();
    end
else
    % load the default cluster profile
    clust=parcluster(dccClusterProfile());
    numw = 16;
    p = parpool(clust, numw);
end
disp(p)

if ispc
    p.addAttachedFiles('c:\Users\Timon\myPSAT\psat\');
else
    p.addAttachedFiles('~/thesis/psat/');
    p.addAttachedFiles('~/thesis/textBar/textBar.m');
end
p.addAttachedFiles(psatFile);
p.addAttachedFiles(mpFile);


% Check all SP's small signal stability
% Progressbar that shows on STDOUT
pw = textBar(N,'Parallel checks');


t2 = tic;
parfor i = 1:N
    [stable(i), classDetails{i}, dampingRatio(i)] = ... 
        DirectedWalks.checkSetpoint(res{i,:},psatFile,mpFile);
    increment(pw)
end
delete(pw)
toc(t2)

fname = strsplit(setPointsCsv,'.');
save([fname{1}  '_summary.mat'],'stable','classDetails','dampingRatio')

%% print
util.printDataSummary(stable, classDetails)
