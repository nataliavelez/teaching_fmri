#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 8000
#SBATCH -t 30
#SBATCH -o reports/model_%j.out
#SBATCH -e reports/model_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
python 2_teaching_model.py