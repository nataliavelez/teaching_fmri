#!/bin/bash
#
#SBATCH -p fasse
#SBATCH -t 24:00:00
#SBATCH -n 1
#SBATCH --mem 8000
#SBATCH -o reports/beta_%j.out
#SBATCH -e reports/beta_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load matlab/R2021a-fasrc01
module load spm/12.7487-fasrc01

matlab -nodisplay -nosplash -r "script_7_teaching_beta;exit"
