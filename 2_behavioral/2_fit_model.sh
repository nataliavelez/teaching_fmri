SUBJECTS=$(sed -z 's/\n/,/g;s/,$/\n/' ../1_preprocessing/outputs/valid_participants.txt)

for m in {0..7}; do
    sbatch --array=$SUBJECTS --job-name="model-$m" 2_fit_model.sbatch $m        
done
