SUBJECTS=$(sed -z 's/\n/,/g;s/,$/\n/' ../1_preprocessing/outputs/valid_participants.txt)

# sbatch --array=$SUBJECTS 1_roi_rsa.sbatch
sbatch --array=1 4_rsa_searchlight.sbatch