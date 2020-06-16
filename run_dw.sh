#!/bin/sh
#BSUB -q elektro
#BSUB -J dw_greedy
#BSUB -W 12:00
#BSUB -n 1 
#BSUB -R "rusage[mem=2GB]"
#BSUB -N 
#BSUB -o out_dw_%J.txt
#BSUB -e error_dw_%J.txt

matlab -nodisplay -nosplash -nodesktop -r "run('~/thesis/PSDC/m3_dw.m');exit;"
