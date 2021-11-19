SUBS=`cat outputs/valid_participants.txt`

for i in $SUBS; do
	SUBJECT=$(printf sub-%02d $i)
        echo "Smoothing data for: " $SUBJECT
        sbatch 5_smooth.sbatch $i
        sleep 1 # give the scheduler a break
done
