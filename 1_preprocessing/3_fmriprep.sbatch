#!/bin/bash
#
#SBATCH -p ncf
#SBATCH -t 24:00:00
#SBATCH -n 4
#SBATCH --mem 32000
#SBATCH -o reports/fmriprep_%j.out
#SBATCH -e reports/fmriprep_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvelez@fas.harvard.edu

module load ncf

IMG_DIR=/ncf/gershman/User/nvelezalicea/fmri_analysis/singularity
IN_DIR=/ncf/gershman/User/nvelezalicea/teaching/BIDS_data
OUT_DIR=$IN_DIR/derivatives
WORK_DIR=/ncf/cushman/Users/nvelezalicea/teaching/work/fmriprep

singularity run $IMG_DIR/fmriprep-20.2.3.simg $IN_DIR $OUT_DIR participant \
	--participant-label $1 -w $WORK_DIR/sub-$1 \
	--nprocs 4 --mem-mb 32000 \
	--fs-no-reconall --notrack --skip_bids_validation -vvv \
	--fs-license-file=/ncf/gershman/User/nvelezalicea/fmri_analysis/license.txt
