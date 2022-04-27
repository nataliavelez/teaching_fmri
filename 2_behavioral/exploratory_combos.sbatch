#!/bin/bash
#
#SBATCH -p fasse
#SBATCH --mem 4000
#SBATCH -t 90
#SBATCH -o reports/combos_%j.out
#SBATCH -e reports/combos_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load Anaconda/5.0.1-fasrc01
source activate py3

python exploratory_combos.py