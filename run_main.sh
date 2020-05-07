#!/bin/sh
#BSUB -q elektro
#BSUB -J main_opf
#BSUB -W 02:00
#BSUB -n 4
#BSUB -R "rusage[mem=8GB]"
#BSUB -N 
#BSUB -o out_main_%J.txt
#BSUB -e Error_main_%J.txt


# ---- execute matlab script -----

matlab -nodisplay -nosplash -nodesktop -r "run('~/thesis/PSDC/main.m');exit;"
