#!/bin/bash
#
#SBATCH -p ncf
#SBATCH -t 6:00:00
#SBATCH -n 1
#SBATCH --mem 8000
#SBATCH -o reports/smooth_%j.out
#SBATCH -e reports/smooth_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load matlab/R2021a-fasrc01
module load spm/12.7487-fasrc01

SUB=$1

matlab -nodisplay -nosplash -r "smooth_fmriprep_outputs($SUB);exit"
