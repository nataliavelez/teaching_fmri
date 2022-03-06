#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 4000
#SBATCH -t 2:00:00
#SBATCH -o reports/recovery_%A_%a.out
#SBATCH -e reports/recovery_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load Anaconda/5.0.1-fasrc01
source activate py3

python QA2_parameter_recovery.py ${SLURM_ARRAY_TASK_ID}
