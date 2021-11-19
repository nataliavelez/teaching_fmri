#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 8000
#SBATCH -t 90
#SBATCH -o reports/copy_%j.out
#SBATCH -e reports/copy_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load Anaconda/5.0.1-fasrc01
source activate py3

python 6_copy_inputs.py