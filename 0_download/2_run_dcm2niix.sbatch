#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 8000
#SBATCH -t 60
#SBATCH -o reports/dcm2nii_%j.out
#SBATCH -e reports/dcm2nii_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf
module load dcm2niix/2019_09_04-ncf

SES=$1
DATA_DIR=/ncf/gershman/User/nvelezalicea/teaching/raw_data/$SES
IN_DIR=$DATA_DIR/RAW
OUT_DIR=$DATA_DIR/nifti

mkdir $OUT_DIR

echo "Processing data from participant: $SES"
echo "Reading data from: $IN_DIR"
echo "Saving data to: $OUT_DIR"

dcm2niix -o $OUT_DIR -v 1 $IN_DIR
