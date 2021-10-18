#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 8000
#SBATCH -t 60
#SBATCH -o reports/bids_%j.out
#SBATCH -e reports/bids_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
python 4_bids.py $1
