% Copyright (c) 2020 Timon Viola

% fit a normal distribution to feasible points
load('.data/case14_dwg/unified_case14_summary.mat')
setpoints = readmatrix(".data/case14_dwg/unified_case14.csv","Delimiter",",");
NSAMPLES = 2e5;

%  
%
idxStablePoints = (stable == 1);
stablePoints = setpoints(idxStablePoints,:);

dim = size(stablePoints);
mu = nan(1,dim(2));
sigma = mu;

for i = 1:dim(2)
    psdc = fitdist(stablePoints(:,i),'Normal');
    mu(i) = psdc.mu;
    sigma(i) = psdc.sigma;
end

%	% fig bivariate normal distribution
%	x1 = -3:0.2:3;
%	x2 = -3:0.2:3;
%	[X1,X2] = meshgrid(x1,x2);
%	X = [X1(:) X2(:)];
%
%	y = mvnpdf(X,mu(1:2),sigma(1:2));
%	y = reshape(y,length(x2),length(x1));
%	surf(x1,x2,y)
%	caxis([min(y(:))-0.5*range(y(:)),max(y(:))])
%	axis([-3 3 -3 3 0 0.4])
%	xlabel('PG1')
%	ylabel('PG2')
%	zlabel('Probability Density')
%% fit multivariate normal distribution
% no - > this is not what I need
% y = mvnpdf(X,mu,sigma);

%% generate multivariate normal random numbers

% calculate covariance
% Ref: https://se.mathworks.com/help/matlab/ref/cov.html
sigma = cov(stablePoints);
% calculate mean
% Ref: https://se.mathworks.com/help/matlab/ref/mean.html
mu = mean(stablePoints);

% fix random nm generator kernel for reproducibility
rng('default')
% get random samples
% Ref: https://se.mathworks.com/help/stats/mvnrnd.html

R = mvnrnd(mu,sigma,NSAMPLES);

fprintf('Sampled %d points \n',NSAMPLES)
%% check results
CASE_FILE = 'case_files/case14.m';
PSAT_FILE = 'case_files/case14_matpower_limits.m';
fname = '.data/case14_dwg/mvnd_2e5_samples.csv';
writematrix(R,fname);
util.add_dependencies
util.dataSummary(fname,PSAT_FILE,CASE_FILE)
