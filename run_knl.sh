#!/bin/bash
date

#run with multiple ranks
mpiexec.hydra -n 16 -ppn 16 ./moab_reproducer ./meshes/tet4_150_16.h5m 
#run with a single rank
./moab_reproducer ./meshes/tet4_150.h5m -o ';'

date

# ---------------------------------------------------
