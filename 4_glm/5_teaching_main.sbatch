#!/bin/bash
#
#SBATCH -p fasse
#SBATCH -t 06:00:00
#SBATCH -n 1
#SBATCH --mem 8000
#SBATCH -o reports/parametric_%A_%a.out
#SBATCH -e reports/parametric_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load matlab/R2021a-fasrc01
module load spm/12.7487-fasrc01

matlab -nodisplay -nosplash -r "fun_teaching_glm('parametric', ${SLURM_ARRAY_TASK_ID});exit"
