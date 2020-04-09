function test_matlab()
    if verLessThan('matlab','9.6')
       warning('PSDC:dependencyVER','Your version of MATLAB was not tested yet, you might encounter unexpected behaviour.\nMATLAB 2019a (9.6) is recommended.') 
    end
end

function test_matpower()
    allToolboxes = ver();
    matpowerNameFun = @(x) allToolboxes(x).Name == "MATPOWER";
    idx = arrayfun(matpowerNameFun,1:numel(allToolboxes));
    % if sum(idx) == 1
    mpVer = allToolboxes(idx);
    if str2num(mpVer.Version) ~= 6
        warning('PSDC:dependencyVER','Your version of MATPOWER was not tested yet, you might encounter unexpected behaviour.\nMATPOWER 6.0 is recommended.') 
    end
end

function test_oopsat()
    allToolboxes = ver();
    tbNameFun = @(x) allToolboxes(x).Name == "OOPSAT";
    idx = arrayfun(tbNameFun,1:numel(allToolboxes));
    mpVer = allToolboxes(idx);
    if str2num(mpVer.Version) < 0
        warning('PSDC:dependencyVER','Your version of MATPOWER was not tested yet, you might encounter unexpected behaviour.\nMATPOWER 6.0 is recommended.') 
    end
end