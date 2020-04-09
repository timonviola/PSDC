#!/bin/sh
#BSUB -q elektro
#BSUB -J data_set
#BSUB -n 24
#BSUB -R "rusage[mem=8GB]"
#BSUB -N s182215@student.dtu.dk
#BSUB -o out_dataSet_%J.txt
#BSUB -e Error_%J.txt
#BUSB -W 00:10
matlab -nodisplay -nosplash -nodesktop -r "run('~/thesis/PSDC/test_psat_par.m');exit;"
