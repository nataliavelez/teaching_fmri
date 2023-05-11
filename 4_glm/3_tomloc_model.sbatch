#!/bin/bash
#
#SBATCH -p ncf
#SBATCH -t 35
#SBATCH -n 1
#SBATCH --mem 8000
#SBATCH -o reports/tomloc_%j.out
#SBATCH -e reports/tomloc_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load matlab/R2021a-fasrc01
module load spm/12.7487-fasrc01

matlab -nodisplay -nosplash -r "script_3_tomloc_model;exit"
