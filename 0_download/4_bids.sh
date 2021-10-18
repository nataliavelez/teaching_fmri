#!/bin/bash

for SES in $(cat session_labels.txt)
do
    echo "Converting data for participant: $SES"
    sbatch 4_bids.sbatch $SES
done
