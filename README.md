[![license](https://img.shields.io/github/license/timonviola/PSDC.svg?style=flat-square)](./LICENSE)

[![GitHub issues](https://img.shields.io/github/issues/timonviola/PSDC)](https://github.com/timonviola/PSDC/issues)

# PSDC
Power System Data set Creation

# Requirements
```
-----------------------------------------------------------------------------------------------------
MATLAB Version: 9.6.0.1307630 (R2019a) Update 7

-----------------------------------------------------------------------------------------------------
MATLAB                                                Version 9.6         (R2019a)
Simulink                                              Version 9.3         (R2019a)
MATPOWER                                              Version 6.0                 
OPTI Toolbox                                          Version 2.28        (R2017b)
Optimization Toolbox                                  Version 8.3         (R2019a)
Parallel Computing Toolbox                            Version 7.0         (R2019a)
Partial Differential Equation Toolbox                 Version 3.2         (R2019a)
Powertrain Blockset                                   Version 1.5         (R2019a)
Statistics and Machine Learning Toolbox               Version 11.5        (R2019a)
Symbolic Math Toolbox                                 Version 8.3         (R2019a)
MDTools


PSAT*                                                 Version 2.1.11      (R2019a)
```
PSAT*: custom modifications were added to the referenced version of the package.



# Installation
Some tips and notes on installing non-trivial dependencies are given below.

## PSAT
PSAT can be downloaded from [http://faraday1.ucd.ie/psat.html](http://faraday1.ucd.ie/psat.html)
however some custom changes/local fixes were added. Consequently, it is recommended
to use the version at [./psat](the local copy).

Upon installation of psat add the psat folder (and its subfolders) to the 
MATLAB path. Make sure to **add PSAT to the bottom** of your MATLAB path list
otherwise internal MATLAB settings will be shadowed.







### Dev notes
MATLAB in cli to output:
https://se.mathworks.com/matlabcentral/answers/91607-how-can-i-redirect-the-command-window-output-to-stdout-and-stderr-when-running-matlab-7-8-r2009a-i#answer_251740
