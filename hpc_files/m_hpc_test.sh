#!/bin/sh
# -- NAME
#BSUB -J hpc_parallel_test
# -- QUE
#BSUB -q elektro
# -- MEMORY PER CORE
#BSUB -R "rusage[mem=2GB]"
# -- EMAIL AT END
#BSUB -N
#BSUB -u s182215@student.dtu.dk
# -- OUTPUT FILE
#BSUB -o output_%J.txt
#BSUB -e ERROR_%J.txt
# -- ESTIMATED TIME [dd:hh:mm:ss]
#BUSB -W 24:00
# -- NUM CORES - this is important
#BSUB -n 1
matlab -nodisplay -nosplash -nodesktop -r "run('hpc_speed_test');exit;"
