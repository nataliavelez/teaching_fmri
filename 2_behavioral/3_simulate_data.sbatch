#!/bin/bash
#
#SBATCH -p fasse
#SBATCH --mem 4000
#SBATCH -t 90
#SBATCH -o reports/simulate_%A_%a.out
#SBATCH -e reports/simulate_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load Anaconda/5.0.1-fasrc01
source activate py3

python 3_simulate_data.py ${SLURM_ARRAY_TASK_ID}