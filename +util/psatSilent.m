% do not display splash msg if true (1)    % feat: add -nosplash option to 
nosplash = 1;                              %     PSAT CLI to surpress splash
% initialize PSAT
initpsat

% do not reload data file on pf run
clpsat.readfile = 0;

% do not display opf message in cmw (e.g.: pf details)
clpsat.mesg = 0;
