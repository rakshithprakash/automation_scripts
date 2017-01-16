for i in 1 2 3 4
do
for j in 1 2 3 4 5
do
(time ./bigswitch$i-fno_jump) &>> output-$i-bigswitch.txt
cat output-$i-bigswitch.txt | egrep "real" | tr -d "s" | tr -d "real" &>> output-$i-bigswitch_time.txt
sleep 5
done
done
