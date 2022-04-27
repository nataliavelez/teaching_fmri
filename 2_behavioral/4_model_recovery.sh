SUBJECTS=$(sed -z 's/\n/,/g;s/,$/\n/' ../1_preprocessing/outputs/valid_participants.txt)

for m in {0..10}; do
    sbatch --array=$SUBJECTS --job-name="model-$m" 4_model_recovery.sbatch $m        
done
