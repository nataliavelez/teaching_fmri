#!/bin/bash
#
#SBATCH -p fasse
#SBATCH --mem 4000
#SBATCH -t 30
#SBATCH -o reports/recovery_%x_%A_%a.out
#SBATCH -e reports/recovery_%x_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load Anaconda/5.0.1-fasrc01
source activate py3

python 4_model_recovery.py $1 ${SLURM_ARRAY_TASK_ID}