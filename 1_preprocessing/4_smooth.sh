for i in {1..30}; do
	SUBJECT=$(printf sub-%02d $i)
	echo "Smoothing data for: " $SUBJECT
	sbatch 4_smooth.sbatch $i
	sleep 1 # give the scheduler a break
done
