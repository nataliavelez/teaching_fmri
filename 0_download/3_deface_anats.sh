#!/bin/bash

IN_DIR=/ncf/gershman/User/nvelezalicea/teaching/raw_data
ANAT_FILES=$(find $IN_DIR -name "*MEMPRAGE*.nii")

for file in $ANAT_FILES; do
    sbatch 3_deface_anats.sbatch $file
done