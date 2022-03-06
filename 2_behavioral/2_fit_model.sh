# MODELS=("utility" "cost" "pedagogical" "strong") # model labels
# MODELS=("utility" "cost" "pedagogical") # model labels
MODELS=("utility")
SUBJECTS=$(sed -z 's/\n/,/g;s/,$/\n/' ../1_preprocessing/outputs/valid_participants.txt)

# first, launch jobs for all models that require model fitting
for m in "${MODELS[@]}"; do
    sbatch --array=$SUBJECTS --job-name=$m 2_fit_model.sbatch $m        
done