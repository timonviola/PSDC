#!/bin/sh
#BSUB -q elektro
#BSUB -J mvnd
#BSUB -W 12:00
#BSUB -n 1 
#BSUB -R "rusage[mem=2GB]"
#BSUB -N 
#BSUB -o out_mvnd_%J.txt
#BSUB -e error_mvnd_%J.txt

matlab -nodisplay -nosplash -nodesktop -r "run('~/thesis/PSDC/m4.m');exit;"
