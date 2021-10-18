#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 32000
#SBATCH -t 5:00:00
#SBATCH -o reports/download_%j.out
#SBATCH -e reports/download_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load yaxil

BASE_DIR=/ncf/gershman/User/nvelezalicea/teaching
SES=$1

ArcGet.py -a cbscentral -p Gershman -l $SES -o $BASE_DIR/raw_data
