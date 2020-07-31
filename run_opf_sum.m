% Copyright (c) 2020 Timon Viola

OUT_DIR = '.data/case68_2020_06_16T105316Z/';
ACOPF_SEED = [OUT_DIR 'case68_ACOPF.csv'];
CASE_FILE = 'case_files/case68.m';
PSAT_FILE = 'case_files/d_case68.m';

fprintf('OUT_DIR: %s\n',OUT_DIR);

util.add_dependencies
util.dataSummary(ACOPF_SEED, PSAT_FILE, CASE_FILE, 'readTableVariables', true)
