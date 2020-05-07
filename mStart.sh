#!/bin/sh
#BSUB -q elektro
#BSUB -J data_set
#BSUB -W 72:00
#BSUB -n 24
#BSUB -R "rusage[mem=8GB]"
#BSUB -N 
#BSUB -o out_dataSet_%J.txt
#BSUB -e Error_%J.txt


# ---- execute matlab script -----

matlab -nodisplay -nosplash -nodesktop -r "run('~/thesis/PSDC/test_psat_par.m');exit;"
