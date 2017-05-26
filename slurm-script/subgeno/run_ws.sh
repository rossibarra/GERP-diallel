#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/GERP-diallel
#SBATCH -o /home/jolyang/Documents/Github/GERP-diallel/slurm-log/testout-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/GERP-diallel/slurm-log/err-%j.txt
#SBATCH -J run_ws
#SBATCH --array=1-7
#SBATCH --mail-user=yangjl0930@gmail.com
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

sh slurm-script/subgeno/run_ws$SLURM_ARRAY_TASK_ID.sh
