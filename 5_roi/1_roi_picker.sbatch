#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 4000
#SBATCH -t 5
#SBATCH -o reports/roi_%A_%a.out
#SBATCH -e reports/roi_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load Anaconda/5.0.1-fasrc01
source activate py3

python 1_roi_picker.py ${SLURM_ARRAY_TASK_ID}
