#!/bin/bash
#----------------------------------------------------
# Sample SLURM job script
#   for TACC Stampede2 KNL nodes
#
#   *** Serial Job on Normal Queue ***
# 
# Last revised: 27 Jun 2017
#
# Notes:
#
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch knl.serial.slurm" on a Stampede2 login node.
#
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- For a good way to run multiple serial executables at the
#        same time, execute "module load launcher" followed
#        by "module help launcher".

#----------------------------------------------------

#SBATCH -J reproducer      # Job name
#SBATCH -o output/reproducer.o%j  # Name of stdout output file
#SBATCH -e output/reproducer.e%j  # Name of stderr error file
#SBATCH -p normal      # Queue (partition) name
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=272
#SBATCH -t 00:05:00        # Run time (hh:mm:ss)
#SBATCH -A TG-MCA03S012    # Allocation name (req'd if you have more than 1)
#SBATCH --exclusive        # X mode

# Other commands must follow all #SBATCH directives...
####XSBATCH -p flat-quadrant   # Queue (partition) name

#module list
cd $(pwd)
#date

# Launch serial code...

date

mpiexec.hydra -n 16 -ppn 16 ./moab_reproducer ./meshes/tet4_150_16.h5m 
./moab_reproducer ./meshes/tet4_150.h5m -o ';'

#mpirun -n 1 ./output/checker

date

# ---------------------------------------------------
