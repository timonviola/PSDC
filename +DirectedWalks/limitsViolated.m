% Check if SP violates min or max PG/VG constraints
%
%

function isViolated = limitsViolated(sp,mmc)

VMAX = 12; VMIN = 13; PMAX = 9; PMIN = 10;
NG = size(mmc.gen,1);
TOL = 1e-3;
sp = sp';
genIdx = util.getGenList(mmc);
vIdx = mmc.gen(:,1);

% -----  generator real power  -----
pChecks = (mmc.gen(genIdx,PMIN)-TOL <= sp(1:NG-1).*mmc.baseMVA) & ...
    (sp(1:NG-1).*mmc.baseMVA <= mmc.gen(genIdx,PMAX)+TOL);
pViolated = ~any(0 == pChecks);

% ----- bus voltage magnitude  -----
vmChecks = (mmc.bus(vIdx,VMIN)-TOL <= sp(NG:end)) &...
    (sp(NG:end) <= mmc.bus(vIdx,VMAX)+TOL);
vViolated = ~any(0 == vmChecks);


isViolated = ~(pViolated & vViolated);
end