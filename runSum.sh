#!/bin/sh
#BSUB -q elektro
#BSUB -J dw_checks
#BSUB -W 12:00
#BSUB -n 1 
#BSUB -R "rusage[mem=2GB]"
#BSUB -N 
#BSUB -o out_sum_%J.txt
#BSUB -e error_sum_%J.txt

matlab -nodisplay -nosplash -nodesktop -r "run('~/thesis/PSDC/run_sum.m');exit;"
