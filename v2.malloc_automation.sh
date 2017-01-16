#Automation script for MALLOC
#set -x
echo -e "\n\t\t\tAUTOMATION SCRIPT OF MALLOC"
echo -e "\t\t\t********** ****** ** ******"
sleep 2

echo -e "\n******************************************************************************"
date=`date`
echo -e "DATE : "$date
echo -e "******************************************************************************\n"

echo -e "\nTHE SCRIPT HAS STARTED EXECUTING...............\n"
sleep 2

system_details() #This function collects the system details
{

echo -e "******************************************************************************"
echo -e "COLLECTING THE SYSTEM DETAILS"
echo -e "******************************************************************************"
#Checking for OS details here

if [ -e /etc/redhat-release ];
   then osdetails=`cat /etc/redhat-release`;

        elif [ -e /etc/SuSE-release ];
                then osdetails=`cat /etc/SuSE-release`;

                        elif [ -e /etc/os-release ];
                                then osdetails=`lsb_release -a 2>/dev/null | grep -i 'Description' | awk '{print $2$3;}'`;

                                        else osdetails=`echo "OSdetails unavailable"`


fi

sleep 2


echo -e "\nTHE SYSTEM DETAILS ARE AS FOLLOWS:\n"
#echo -e "******************************************************************************"

echo -e "OS : "$osdetails | tee -a system_config.txt

machine=`cat /proc/cpuinfo | grep machine`
echo -e $machine | tee -a system_config.txt

nodename=`uname -n`
echo -e "Node name : "$nodename | tee -a system_config.txt

kernelrelease=`uname -r`
echo -e "Kernel Release : "$kernelrelease | tee -a system_config.txt

architecture=`lscpu | grep Architecture`
echo -e $architecture | tee -a system_config.txt

byteorder=`lscpu | grep Byte`
echo -e $byteorder | tee -a system_config.txt

smt_mode=`lscpu | grep Thread | awk '{print $4;}'`
echo -e "SMT Mode : "$smt_mode | tee -a system_config.txt

no_of_cores=`lscpu | grep Core |  awk '{ print $4;}'`
#sockets=`lscpu | grep Socket | awk '{print $2;}'`
#no_of_cores=`expr $cores \* $sockets`

echo -e "Number of  Cores : "$no_of_cores | tee -a system_config.txt

no_of_threads=`nproc`
echo -e "Number of Threads : "$no_of_threads | tee -a system_config.txt
sleep 5
}

count_lines=`wc -l textfile.txt | awk '{print $1}'`
#echo "count_lines" $count_lines
lib=0
base_count=0

#This function is to run the tests

run_tests()
{

        cd /home/ashok/malloc/MW2/PROGS/WM2TEST

        #echo $line

        for i in 1 2 3
        do
                ./@_@g++64_wm2_benchmark $line 2>> "$basedir/pattern_output/$line.$lib"
        done

}

#This function calculates the average etime of the collected data
extract_etime()
{
        mkdir -p $basedir/etime_output
        echo -e "\nThe data collected is :\n"
        cat "$basedir/pattern_output/$line.$lib"
        output=`cat "$basedir/pattern_output/$line.$lib" | grep "Resources" | awk 'BEGIN{cnt=0;tot=0;}{cnt+=1;tot+=$10} END {printf("%f\n",tot/cnt);}'`
        echo -e "\nThe average etime of $line for $LD_LIBRARY_PATH is :" $output | tee -a "$basedir/etime_output/$line.$lib"
        echo -e "\n"
}

system_details

#This function collects the ldd information
ldd_information()
{
        cd /home/ashok/malloc/MW2/PROGS/WM2TEST
        ldd @_@g++64_wm2_benchmark
}

for i in `seq 1 4`
do
        #echo "main loop " $i

        while read line
        do


                if [ $lib -eq 0 ]
                then
                        #echo ""$base_count
                        export LD_LIBRARY_PATH=/home/ashok/glibcinstall/lib;
                        echo $LD_LIBRARY_PATH
                        ldd_information


                elif [ $lib -eq 1 ]
                then
                        export LD_LIBRARY_PATH=/home/ashok/glibcinstall_elision_yes/lib;
                         echo $LD_LIBRARY_PATH
                        ldd_information


                elif [ $lib -eq 2 ]
                then
                        export LD_LIBRARY_PATH=/home/ashok/glibcinstall_elision_no/lib;
                         echo $LD_LIBRARY_PATH
                        ldd_information


                elif [ $lib -eq 3 ]
                then
                        export LD_LIBRARY_PATH=/home/ashok/glibcinstall_elision_no_disable_experimental/lib;
                        echo $LD_LIBRARY_PATH
                        ldd_information


                else
                        echo $LD_LIBRARY_PATH
                         ldd_information
                fi


basedir="/home/auto/malloc"
mkdir -p $basedir/pattern_output
mkdir -p $basedir/perf_record_output

#function 1 : For running the tests

run_tests

perf record -e cycles -c 1000000 -o "$basedir/perf_record_output/perf.malloc.rak.$line.$lib" ./@_@g++64_wm2_benchmark $line 2>> "$basedir/perf_record_output/$line.$lib"
perf report -n -i "$basedir/perf_record_output/perf.malloc.rak.$line.$lib" --stdio >> "$basedir/perf_record_output/$line.$lib"

extract_etime

done < textfile.txt

cd $basedir

lib=`expr $lib + 1`

done
