for i in {1..30}
do
    SUB=$(printf sub-%02d $i)
    echo $SUB
    sbatch 3_fmriprep.sbatch $SUB
done
