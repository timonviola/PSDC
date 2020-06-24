function samples = getHICSamplesRnd(setPoint, MPC, varargin)


N = 1e3;
tol = 0.05;

samples = rand(N,length(setPoint));
alpha = DirectedWalks.getAlpha(MPC);
% scale
samples = samples.*alpha' + setPoint;
% figure;
% axes;
% plot3(samples(:,1),samples(:,2),samples(:,3),'.');
% hold on;

samples = uniquetol(samples,tol,'ByRows',true);

% plot3(samples(:,1),samples(:,2),samples(:,3),'r.');