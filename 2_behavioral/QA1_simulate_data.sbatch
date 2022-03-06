#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 4000
#SBATCH -t 3:00:00
#SBATCH -o reports/simulate_%j.out
#SBATCH -e reports/simulate_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load Anaconda/5.0.1-fasrc01
source activate py3

python QA1_simulate_data.py