#!/bin/sh
#BSUB -q elektro
#BSUB -J dwf_c68
#BSUB -W 12:00
#BSUB -n 1 
#BSUB -R "rusage[mem=2GB]"
#BSUB -N 
#BSUB -o out_dw_c68_%J.txt
#BSUB -e error_dw_c68_%J.txt

matlab -nodisplay -nosplash -nodesktop -r "run('~/thesis/PSDC/m3_dw.m');exit;"
