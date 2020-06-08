#!/bin/sh
FP=${1?Error: no path given}
FN=${2?Error: no file given}
echo "mkdir ~/thesis/PSDC/$FP"
echo "cp ~/thesis/PSDC/$FP/$FN"

ssh s182215@login.gbar.dtu.dk "mkdir ~/thesis/PSDC/$FP"
scp "$FP/$FN" s182215@transfer.gbar.dtu.dk:thesis/PSDC/$FP
scp "$FP/j_opf.sh" s182215@transfer.gbar.dtu.dk:thesis/PSDC/$FP