#!/bin/bash

for SES in $(cat session_labels.txt)
do
    echo "Converting data for participant: $SES"
    sbatch 2_run_dcm2niix.sbatch $SES
done
