% after util.dataSummary
%load('summary_res_case9.mat')
figure
axes

stairs(dampingRatio)
hold on
yline(0.0325,':b')
yline(0.0275,':b')