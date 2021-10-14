#!/bin/bash

for SES in $(cat session_labels.txt)
do
	sbatch 1_download_sessions.sbatch $SES
done
