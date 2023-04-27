#for m in parametric empirical control
for m in parametric pragmatic control
do
    echo $m
    sbatch --job-name=$m --array=0-6 QA_1_teaching_separate.sbatch $m
done
