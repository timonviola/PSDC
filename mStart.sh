#!/bin/sh
#BSUB -q elektro
#BSUB -J data_set
#BSUB -n 24
#BSUB -R "rusage[mem=8GB]"
#BSUB -N s182215@student.dtu.dk
#BSUB -o out_dataSet_%J.txt
#BSUB -e Error_%J.txt
#BUSB -W 00:10
matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('~/thesis/matpower6.0/')); addpath(genpath('~/thesis/psat/'));run('~/thesis/software/testo');exit;"
