#!/bin/bash
#
#SBATCH -p fasse
#SBATCH -t 12:00:00
#SBATCH -n 1
#SBATCH --mem 8000
#SBATCH -o reports/parametric_%j.out
#SBATCH -e reports/parametric_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load matlab/R2021a-fasrc01
module load spm/12.7487-fasrc01

matlab -nodisplay -nosplash -r "script_5_teaching_main;exit"
