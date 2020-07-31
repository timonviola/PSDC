%LIMITSVIOLATED Check PG,VG limit violations.
%   valid = LIMITSVIOLATED(setpoint,mmc) Checks if setpoint violates min or
%   max PG and VG constraints defined in mmc MATPOWER struct. Returns
%   logical true if any of the limits is violated.
%
%   Example
% 
%   See also DIRECTEDWALKS.DWG, DIRECTEDWALKS.DWG_S
% 

% Copyright (C) 2020 Timon Viola
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