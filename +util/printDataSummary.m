% PRINTDATASUMMARY Formatted output of plotDataSummary.
% See also UTIL.PLOTDATASUMMARY

% Copyright (C) 2020 Timon Viola
function printDataSummary(stable, classDetails)

fprintf('\n<strong>Summary</strong>\n')
fprintf(pad('',25,'right','-'))
fprintf('\nNumber of points:%22d\n',length(stable))
fprintf('Number of stable points:%15d\n',sum(stable))
fprintf('Dataset ratio:%28.2f%%\n',100 * sum(stable)/length(stable))
critNames = ["PG","QG","VM","Sf","SSS"];

disp('Stability per criterion')
sPercentage = sum(cell2mat(classDetails),1)./length(stable) *100;
for i = 1:length(critNames)
    fprintf('%11s\t%30.2f%%\n',critNames(i),sPercentage(i))
end


dets = cell2mat(classDetails);
nACOPF = sum(sum(dets(:,1:4),2) == 4);
nSSS = sum(sum(dets(:,5),2) == 1);
nStable = sum(stable);
fprintf('Fully stable points\n')
fprintf('\t\tACOPF:\t%10d\t%2.2f%%\t%2.2f%%\n',...
    nACOPF,nACOPF./length(stable) *100,nACOPF/nStable * 100)
fprintf('\t\tSSS:\t%10d\t%2.2f%%\t%2.2f%%\n',...
    nSSS,nSSS./length(stable) *100,nSSS/nStable * 100)
fprintf('\t\tall:\t%10d\t%2.2f%%\t%2.2f%%\n',...
    nStable,nStable./length(stable) *100,nStable/nStable * 100)


% create table



