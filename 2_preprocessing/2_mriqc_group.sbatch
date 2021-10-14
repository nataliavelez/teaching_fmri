#!/bin/bash
#
#SBATCH -p ncf
#SBATCH --mem 32000
#SBATCH -t 16:00:00
#SBATCH -o reports/mriqc_%j.out
#SBATCH -e reports/mriqc_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf

IMG_DIR=/ncf/gershman/User/nvelezalicea/fmri_analysis/singularity
IN_DIR=/ncf/gershman/User/nvelezalicea/teaching/BIDS_data
OUT_DIR=$IN_DIR/derivatives/mriqc

singularity run $IMG_DIR/mriqc-0.16.1.simg $IN_DIR $OUT_DIR group --mem-gb 32 -w /tmp/nvelezalicea/mriqc/group
