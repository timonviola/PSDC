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
module load matlab/R2019a
module load julia/1.1.1
export PATH=/app/R/3.6.3-mkl2020/bin:$PATH

matlab -nodisplay -batch "/zhome/6b/5/134657/thesis/PSDC/call_julia.m"
