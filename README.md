![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/timonviola/PSDC)
[![license](https://img.shields.io/github/license/timonviola/PSDC.svg?style=flat-square)](./LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/timonviola/PSDC)](https://github.com/timonviola/PSDC/issues)
![semver](https://img.shields.io/badge/semver-2.0.0-blue)
 
# PSDC
Power System Data set Creation

# Requirements
```
-----------------------------------------------------------------------------------------------------
MATLAB Version: 9.6.0.1307630 (R2019a) Update 7

-----------------------------------------------------------------------------------------------------
MATLAB                                                Version 9.6         (R2019a)
MATPOWER                                              Version 6.0                 
OPTI Toolbox                                          Version 2.28        (R2017b)
Optimization Toolbox                                  Version 8.3         (R2019a)
Parallel Computing Toolbox                            Version 7.0         (R2019a)
Statistics and Machine Learning Toolbox               Version 11.5        (R2019a)
Symbolic Math Toolbox                                 Version 8.3         (R2019a)
OOPSAT                                                Version 0.1         (R2020a)
```
PSAT*: custom modifications were added to the referenced version of the package.

```
Julia                                                 v1.0.*
  "Suppressor"  => v"0.2.0"
  "JuMP"        => v"0.21.2"
  "Distributed" => nothing
  "Ipopt"       => v"0.6.1"
  "Memento"     => v"1.0.0"
  "PowerModels" => v"0.15.4"
  "ArgParse"    => v"1.1.0"
```
```
R version 4.0.0 (2020-04-24)
  volesti_1.1.0 Rcpp_1.0.4.6        https://github.com/cran/volesti/tree/1.1.0
  compiler_4.0.0   tools_4.0.0      codetools_0.2-16
```

# Installation
Some tips and notes on installing non-trivial dependencies are given below.
All dependencies are listed above.

Download or even better - clone PSDC and add it to your MATLAB path. You might want to add the subpackages of PSDC as well to prevent extensive usage of `import`.

## OOPSAT
PSDC builds on OOPSAT, which can be downloaded from here [OOPSAT](https://github.com/timonviola/oopsat). After downloading make sure that you add OOPSAT to your MATLAB path (recommended to add it to the bottom of your path list).

PSAT can be downloaded from [http://faraday1.ucd.ie/psat.html](http://faraday1.ucd.ie/psat.html)
however some custom changes/local fixes are added. Consequently, it is recommended
to use OOPSAT.

# Tests
To check if all (MATLAB) dependencies are properly installed run
```matlab
import matlab.unittest.TestSuite;
suite = TestSuite.fromPackage('test')
res = run(suite)
```





### Dev notes
MATLAB in cli to output:
https://se.mathworks.com/matlabcentral/answers/91607-how-can-i-redirect-the-command-window-output-to-stdout-and-stderr-when-running-matlab-7-8-r2009a-i#answer_251740
