% SOFTWARE
% Version 0.1.3 03-Jun-2020
% Files
%   call_julia    - ----- local -----
%   m1            - 
%   m2            - ACOPF checks on samples
%   main          - 
%   plot3Dobjects - 
%   qc_relaxation.jl
%     usage: qc_relaxation.jl [-l LOG] [-v VOL] [-t TIGHTENED]
%                             [-A OUT_FILE_NAME_A] [-b OUT_FILE_NAME_B]
%                             [-x OUT_FILE_NAME_X] [-h] case_file_name
%                             number_of_iterations out_samples_file_name
%                             n2_number_of_samples
%     
%     positional arguments:
%       case_file_name        Case file name (relative or full path with
%                             extension).            Supported file formats:
%                             - matpower v2.0
%       number_of_iterations  Number of polytopes added. (type: Int64)
%       out_samples_file_name
%                             Output file containing N2 number of uniform
%                             samples from the            convex polytope.
%                             File fullpath should be defined including the
%                             extension (.csv).
%       n2_number_of_samples  N2 number of samples from the convex polytope.
%                             (type: Int64)
%     
%     optional arguments:
%       -l, --log LOG         Define log level. Possible values are: [debug
%                             | info |            notice | warn | error].
%                             (default: "info")
%       -v, --vol VOL         Save A,b polytope data. Define the frequency
%                             of saving files            e.g.: -v 1000 means
%                             that A,b data saved in every 1000th iteration.
%                             (type: Int64, default: 0)
%       -t, --tightened TIGHTENED
%                             Tightened output case file name (relative or
%                             full path with            extension).
%                             Supported file formats:        - matpower v2.0
%       -A, --out_file_name_A OUT_FILE_NAME_A
%                             Output file of the convex polytope's A matrix.
%                             File fullpath            should be defined
%                             including the extension (.csv).
%       -b, --out_file_name_B OUT_FILE_NAME_B
%                             Output file of the convex polytope's b vector.
%                             File fullpath            should be defined
%                             including the extension (.csv).
%       -x, --out_file_name_X OUT_FILE_NAME_X
%                             Output file of optimal set points. The first
%                             row contains the            variable names.
%       -h, --help            show this help message and exit
%
%       EXAMPLES
%           Call with detailed runtime information (debug) and save
%           polytope A,b matrices for every 10th added polytope:
%           !julia qc_relaxation.jl -l debug -v 10 "case_files/case9.m"...
%               "100" ".data\case9_QCRM_10.csv"  "100"
%
%   opf_par.jl
%     usage: opf_par.jl [-l LOG] [-h] out_file_name case_file_name samples
% 
%     positional arguments:
%       out_file_name   Output file containing the Pg and Vg values of the
%                       sovled            AC-OPFs.
%       case_file_name  Case file name (relative or full path with
%                       extension).            Supported file formats:
%                       - matpower v2.0
%       samples         .csv file containing the samples from the convex
%                       polytope            of several QC relaxation runs.
% 
%     optional arguments:
%       -l, --log LOG   Define log level. Possible values are: [debug | info
%                       |            notice | warn | error]. (default:
%                       "info")
%       -h, --help      show this help message and exit
%
%   qc_relaxation_methods.jl - Julia functions.
