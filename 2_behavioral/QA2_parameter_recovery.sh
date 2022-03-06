N_FILES=$(ls outputs/simulated_data | wc -l )
MAX=$((N_FILES - 1))

sbatch --array=0-$MAX QA2_parameter_recovery.sbatch 