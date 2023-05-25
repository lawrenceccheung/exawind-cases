#!/bin/bash

#SBATCH --job-name=amr_alm
#SBATCH --account=hfm
#SBATCH --nodes=29
#SBATCH --time=48:00:00
#SBATCH --output=out.%x_%j
#SBATCH --qos=high
##SBATCH --switches=2

#source ~/.bash_profile
#amr_env gcc
module purge
module load gcc
module load mpt
module load cmake
#module load netcdf-c/4.7.3

#export EXAWIND_DIR=/nopt/nrel/ecom/exawind/exawind-2020-09-21/install/gcc

ranks_per_node=36
mpi_ranks=$(expr $SLURM_JOB_NUM_NODES \* $ranks_per_node)
export OMP_NUM_THREADS=1  # Max hardware threads = 4
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

#amr_exec=/home/lmartine/amr-wind-tony/build/amr_wind
amr_exec=/home/lmartine/amr-wind-tony/build/amr_wind

echo "Job name       = $SLURM_JOB_NAME"
echo "Num. nodes     = $SLURM_JOB_NUM_NODES"
echo "Num. MPI Ranks = $mpi_ranks"
echo "Num. threads   = $OMP_NUM_THREADS"
echo "Working dir    = $PWD"

cp ${amr_exec} $(pwd)/amr_wind

rm -rf post_processing

#srun -n 512  -c 1 --cpu_bind=cores $(pwd)/amr_wind alm.yaml  #> out.log 2>&1
srun -n 1024  -c 1 --cpu_bind=cores $(pwd)/amr_wind alm.yaml  #> out.log 2>&1
#srun -n 256  -c 1 --cpu_bind=cores $(pwd)/amr_wind alm.yaml  > out.log 2>&1
#srun -n 32  -c 1 --cpu_bind=cores $(pwd)/amr_wind alm.yaml  > out.log 2>&1
#srun -n 2048  -c 1 --cpu_bind=cores $(pwd)/amr_wind alm.yaml  > out.log 2>&1
#srun -n ${mpi_ranks} -c 1 --cpu_bind=cores $(pwd)/amr_wind inputabl.i
