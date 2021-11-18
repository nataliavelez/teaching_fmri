for i in {1..30}
do
    SUB=$(printf sub-%02d $i)
    echo $SUB
    sbatch 1_mriqc_participant.sbatch $SUB
done
