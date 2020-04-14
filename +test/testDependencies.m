% import matlab.unittest.TestSuite;
% suite = TestSuite.fromPackage('test')
% res = run(suite)

function tests = testDependencies
% TESTDEPENDENCIES checks the availability of the necessary toolboxes.
    tests = functiontests(localfunctions);
end


function testMatlabVersion(testCase)
d = dbstack;
fprintf(pad(d(1).name,50,'right','.'))
verifyTrue(testCase,verLessThan('matlab','9.7'),'Your version of MATLAB was not tested yet, you might encounter unexpected behaviour.\nMATLAB 2019a (9.6) is recommended.')
fprintf('COMPLETED\n')
%     if verLessThan('matlab','9.7')
%        warning('PSDC:dependencyVER','Your version of MATLAB was not tested yet, you might encounter unexpected behaviour.\nMATLAB 2019a (9.6) is recommended.') 
%     end
end

function testMatpowerVersion(testCase)
    d = dbstack;
    fprintf(pad(d(1).name,50,'right','.'))
    allToolboxes = ver();
    matpowerNameFun = @(x) allToolboxes(x).Name == "MATPOWER";
    idx = arrayfun(matpowerNameFun,1:numel(allToolboxes));
    % if sum(idx) == 1
    mpVer = allToolboxes(idx);
    verifyTrue(testCase,str2num(mpVer.Version) == 6,'Your version of MATPOWER was not tested yet, you might encounter unexpected behaviour.\nMATPOWER 6.0 is recommended.')
    fprintf('COMPLETED\n')
%     if str2num(mpVer.Version) ~= 6
%         warning('PSDC:dependencyVER','Your version of MATPOWER was not tested yet, you might encounter unexpected behaviour.\nMATPOWER 6.0 is recommended.') 
%     end
end

function testOopsatVersion(testCase)
    d = dbstack;    
    fprintf(pad(d(1).name,50,'right','.'))
    allToolboxes = ver();
    tbNameFun = @(x) allToolboxes(x).Name == "OOPSAT";
    idx = arrayfun(tbNameFun,1:numel(allToolboxes));
    mpVer = allToolboxes(idx);
    verifyTrue(testCase,str2num(mpVer.Version) > 0,'Your version of MATPOWER was not tested yet, you might encounter unexpected behaviour.\nMATPOWER 6.0 is recommended.')
    fprintf('COMPLETED\n')
%     if str2num(mpVer.Version) < 0
%         warning('PSDC:dependencyVER','Your version of MATPOWER was not tested yet, you might encounter unexpected behaviour.\nMATPOWER 6.0 is recommended.') 
%     end
end