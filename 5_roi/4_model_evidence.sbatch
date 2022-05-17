#!/bin/bash
#
#SBATCH -p fasse
#SBATCH -t 2:00:00
#SBATCH -n 1
#SBATCH --mem 8000
#SBATCH -o reports/model_%j.out
#SBATCH -e reports/model_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load matlab/R2021a-fasrc01
module load spm/12.7487-fasrc01

matlab -nodisplay -nosplash -r "script_4_model_evidence;exit"
