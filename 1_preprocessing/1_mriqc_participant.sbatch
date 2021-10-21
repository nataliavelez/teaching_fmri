#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 32000
#SBATCH -t 12:00:00
#SBATCH -o reports/mriqc_%j.out
#SBATCH -e reports/mriqc_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf

IMG_DIR=/ncf/gershman/User/nvelezalicea/fmri_analysis/singularity
IN_DIR=/ncf/gershman/User/nvelezalicea/teaching/BIDS_data
OUT_DIR=$IN_DIR/derivatives/mriqc
WORK_DIR=/ncf/cushman/Users/nvelezalicea/teaching/work/mriqc

singularity run $IMG_DIR/mriqc-0.16.1.simg $IN_DIR $OUT_DIR \
    participant --participant_label $1 --mem-gb 32 -w $WORK_DIR/sub-$1 \
    --no-sub -vvv
