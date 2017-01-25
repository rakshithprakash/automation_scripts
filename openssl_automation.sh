no_of_inst=4000 #number-of-instructions
debug_mess=5000 #prints one debug message after the number of istructions specified here
start_instr=100 #start instructions
end_instr=3500 #end instructions
num_inst_collect=4 #Numbers of K instructions to collect

download_and_compile_openssl()
{
wget https://www.openssl.org/source/openssl-1.1.0c.tar.gz || git clone https://github.com/openssl/openssl.git || ( echo "check connection settings" && exit 0 )

tar -xvf openssl-1.1.0c.tar.gz || cd openssl || ( echo "can't find folder" && exit 0 )

mv openssl-1.1.0c openssl

rm openssl-1.1.0c.tar.gz

cd openssl

./config

if [ $? -ne 0 ] #Checking if configuration is successful or not
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Configuration is successful\n"

        fi


sleep 3

make all

if [ $? -ne 0 ] #Checking if configuration is successful or not
                 then echo -e "Make is not successful or already compiled\n"

                        else
                                echo -e "Make is successful\n"

        fi



sleep 3

export LD_LIBRARY_PATH=`pwd`

cd apps
}

change_to_openssl_directory()
{
cd openssl

export LD_LIBRARY_PATH=`pwd`

cd apps
}

pmu_not_found()
{
cp  $pmu_location/pmu.sh `pwd`
chmod 777 pmu.sh
}

pmu_location=`pwd`



#/opt/at9.0/bin/valgrind –tool=itrace --binary-outfile=itrace.$2.vgi –fnname=$do_one –num-K-insns-to-collect=$num_inst_collect ./openssl speed $1
#/opt/at9.0/bin/valgrind --tool=itrace --binary-outfile=itrace.$2.vgi --fnname=$do_one --num-K-insns-to-collect=$num_inst_collect ./openssl speed $1


#function collect_trace_file_in_readable_format
#{
#/opt/at9.0/bin/valgrind --tool=itrace --readable=yes --fnname=$do_one --num-K-insns-to-collect=$num_inst_collect ./openssl speed $1
#}






if [ ! -d openssl ]
then
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo " Downloading running and compiling openssl"
echo "++++++++++++++++++++++++++++++++++++++++++++++"
download_and_compile_openssl

else

echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo "changing to openssl directory"
echo "++++++++++++++++++++++++++++++++++++++++++++++"
change_to_openssl_directory

fi

echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "recording the data"
echo "+++++++++++++++++++++++++++++++++++++++++++++"
./openssl speed $1 > $2_openssl_output.txt
perf record -o $2.graph --call-graph fp -c 1000000 -- ./openssl speed $1

if [ ! -f pmu.sh ]
then
pmu_not_found

else
chmod 777 pmu.sh
fi
./pmu.sh $1

##copy these functions first and put it in the top of the file
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "collecting the file report"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sleep 3

 perf report --call-graph -i $2.graph --no-children > $2_perf_report.txt

 do_one=`cat $2_perf_report.txt | awk '{print $5}'| head -12 |tail -1`

sleep 3

echo "***************************************"
echo "collecting and generating_scroll_pipe_data"
echo "***************************************"

#collect_trace_file
/opt/at9.0/bin/valgrind --tool=itrace --binary-outfile=itrace.$2.vgi --fnname=$do_one --num-K-insns-to-collect=$num_inst_collect ./openssl speed $1

#convert_itrace_format_to_qtrace_format
/opt/at9.0/bin/vgi2qt -f itrace.$2.vgi -o $2.qt
#generate_scroll_pipe_data

#./run_timer $2.qt $no_of_inst $debug_mess 1 $2.output.log -scroll_pipe 1 -b $start_instr -e $end_instr

