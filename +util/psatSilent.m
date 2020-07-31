% Initialize PSAT with all messages surpresssed.

% Copyright (C) 2020 Timon Viola
ps = psat('command_line_psat',true,'nosplash',true);

% do not reload data file on pf run
ps.clpsat.readfile = 0;

% do not display opf message in cmw (e.g.: pf details)
ps.clpsat.mesg = 0;
