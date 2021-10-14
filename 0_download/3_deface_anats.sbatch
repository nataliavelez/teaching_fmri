#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 16000
#SBATCH -t 20
#SBATCH -o reports/deface_%j.out
#SBATCH -e reports/deface_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load fsl/6.0.4-ncf

pydeface $1
