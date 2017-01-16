#!/bin/bash

#Purpose : To automate OOB functions

#Authors : Rakshith Prakash (rakshith.prakash@in.ibm.com),Vijay K Puliyala (vpuliyal@in.ibm.com)


echo -e "\n\t\t\tAUTOMATION SCRIPT OF OOB FUNCTIONS"
echo -e "\t\t\t********** ****** ** *** *********"
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


echo -e "\nTHE SYSTEM DETAILS ARE AS FOLLOWS:\n"
#echo -e "******************************************************************************"

echo -e "OS : "$osdetails

machine=`cat /proc/cpuinfo | grep machine`
echo -e $machine

nodename=`uname -n`
echo -e "Node name : "$nodename

kernelrelease=`uname -r`
echo -e "Kernel Release : "$kernelrelease

architecture=`lscpu | grep Architecture`
echo -e $architecture

byteorder=`lscpu | grep Byte`
echo -e $byteorder

smt_mode=`lscpu | grep Thread | awk '{print $4;}'`
echo -e "SMT Mode : "$smt_mode

no_of_cores=`lscpu | grep Core |  awk '{ print $4;}'`
#sockets=`lscpu | grep Socket | awk '{print $2;}'`
#no_of_cores=`expr $cores \* $sockets`

echo -e "Number of  Cores : "$no_of_cores

no_of_threads=`nproc`
echo -e "Number of Threads : "$no_of_threads
}

path=`pwd` #User path - keeping it to perform all the operations in the same folder.
cd $path
system_details #Calling the system details function to display system details

#Help file to guide the user on how to use the script
if [ $# -eq 0 ] #It gets executed when user does not provide any arguments
    then
            echo -e "\n*********************************************************************************************"
            echo -e "Please enter in the following format : RunOOB <functionname> <perf>"
            echo -e "Functions available : aesgcm,raid5_2,raid5_5,hash64,jhash,stackprotector,volatile,bigswitch"
            echo -e "RunOOB <functionname> : Just compiles the functions"
            echo -e "RunOOB <functionname> <perf> : Compiles and also provides perf data"
            echo -e "*********************************************************************************************\n"
fi

aesgcm () #Aesgcm function
{
        echo -e "\n***************"
        echo -e "AESGCM SELECTED"
        echo -e "***************\n"
        mkdir -p aesgcm
        cd $path/aesgcm
        echo -e "\n***************"
        echo -e "Starting AESGCM\n"
        echo -e "***************\n"
        sleep 2
        tar -xvf openssl-1.0.2d.tar.gz > /dev/null 2>&1
        sleep 2
        /usr/bin/gcc -Wall -O2 -o aesgcm $path/aesgcm.c -lcrypto
        if [ $? -ne 0 ] #Checking if compilation is successful or not
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of aesgcm is successful\n"

        fi
        sleep 3
        /usr/bin/gcc -Wall -O2 -DSMALL  -o aesgcm-small $path/aesgcm.c -lcrypto
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of aesgcm small  is successful\n"

        fi
        echo -e "\nThe output file is in the following directory : $path/aesgcm\n"
}

raid5_2 ()
{
        echo -e "\n*******"
        echo -e "RAID5_2"
        echo -e "*******\n"
        mkdir -p raid5_2
        cd $path/raid5_2
        echo -e "\n****************"
        echo -e "Starting RAID5_2"
        echo -e "****************\n"
        sleep 2
        /usr/bin/gcc -Wall -O2 -o raid5_2 $path/raid5_xor_2.c
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of raid5 xor 2 is successful\n"

        fi
        echo -e "\nThe output file is in the following directory :  $path/raid5_2\n"

}

raid5_5 ()
{
        echo -e "\n*******"
        echo -e "RAID5_5"
        echo -e "*******\n"
        mkdir -p raid5_5
        cd $path/raid5_5
        echo -e "\n****************"
        echo -e "Starting RAID5_5"
        echo -e "****************\n"
        sleep 2
        /usr/bin/gcc -Wall -O2 -o raid5_5 $path/raid5_xor_5.c
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of raid5 xor 2 is successful\n"

        fi
        echo -e "\nThe output file is in the following directory :  $path/raid5_2\n"

}

hash64 ()
{
        echo -e "\n******"
        echo -e "HASH64"
        echo -e "******\n"
        mkdir -p hash64
        cd $path/hash64
        echo -e "\n****************"
        echo -e "Starting Hash_64"
        echo -e "****************\n"
        sleep 2
        /usr/bin/gcc -Wall -O2 -o hash64 $path/hash_64.c
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of hash64 is successful\n"

        fi
        sleep 2
        /usr/bin/gcc -Wall -O2 -DCONFIG_ARCH_HAS_FAST_MULTIPLIER -o hash64_dconfig $path/hash_64.c
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of hash64_config is successful\n"

        fi
        echo -e "\nThe output file is in the following directory :  $path/hash64\n"
}

jhash ()
{
        echo -e "\n*****"
        echo -e "JHASH"
        echo -e "*****\n"
        mkdir -p jhash
        cd $path/jhash
        echo -e "\n**************"
        echo -e "Starting Jhash"
        echo -e "**************\n"
        sleep 2
        /usr/bin/gcc -Wall -O2 -o jhash $path/jhash.c
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of jhash is successful\n"

        fi
        echo -e "\nThe output file is in the following directory :  $path/jhash\n"
}

stackprotector ()
{
        echo -e "\n**************"
        echo -e "STACKPROTECTOR"
        echo -e "**************\n"
        mkdir -p stackprotector
        cd $path/stackprotector
        echo -e "\n***********************"
        echo -e "Starting Stackprotector"
        echo -e "***********************\n"
        sleep 2
        /usr/bin/gcc -Wall -O2 -o stackprotector $path/stackprotector.c
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of Stackprotector is successful\n"

        fi
        sleep 2
        /usr/bin/gcc -Wall -O2 -fno-stack-protector $path/stackprotector.c -o stackprotector_fno
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of Stackprotector-fno is successful\n"

        fi

        /usr/bin/gcc -Wall -O2 -fstack-protector-strong $path/stackprotector.c -o stackprotector_strong
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of Stackprotector-strong is successful\n"

        fi

        echo -e "\nThe output file is in the following directory :  $path/stackprotector\n"

}

volatilelhs ()
{
        echo -e "\n************"
        echo -e "VOLATILE-LHS"
        echo -e "************\n"
        mkdir -p volatile-lhs
        cd $path/volatile-lhs
        echo -e "\n*********************"
        echo -e "Starting Volatile-lhs"
        echo -e "*********************\n"
        sleep 2
        /usr/bin/gcc -Wall -O2 -o volatilelhs $path/volatile-lhs.c
        if [ $? -ne 0 ]
                 then echo -e "Compilation is not successful or already compiled\n"

                        else
                                echo -e "Compilation of Volatile-lhs is successful\n"

        fi
        echo -e "\nThe output file is in the following directory :  $path/volatile-lhs\n"
}

bigswitch ()
{
        echo -e "\n*********"
        echo -e "BIGSWITCH"
        echo -e "*********\n"
        mkdir -p bigswitch
        cd $path/bigswitch
        COUNT=1
        while [  $COUNT -lt 5 ]; do
                echo -e "\n*********************************"
                echo -e "Starting bigswitch$COUNT workload"
                echo -e "*********************************\n"
                gcc -Wall -O2 -o bigswitch$COUNT $path/bigswitch$COUNT.c
                if [ $? -ne 0 ]
                        then echo -e "Compilation is not successful or already compiled\n"

                                else
                                        echo -e "Compilation of Bigswitch$COUNT is successful\n"

                fi
        COUNT=$[$COUNT+1]
        done
        echo -e "\nThe output file is in the following directory :  $path/bigswitch\n"
}



if [ "$1" = "aesgcm" ]; #checking for 1st argument
    then
    aesgcm
        if [ "$2" = "perf" ]; #checking for 2nd argument
                then
                echo -e "Collecting perf stat\n"
                (perf stat -e cycles,r500fa,r5301c2 ./aesgcm-small) >> perf.stat.aesgcm-small_output.txt 2>&1 #collecting perf stat
                sleep 2
                (perf stat -e cycles,r500fa,r5301c2 ./aesgcm) >> perf.stat.aesgcm_output.txt 2>&1
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.aesgcm-small ./aesgcm-small #Collecting perf data
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.aesgcm ./aesgcm
                sleep 2
                echo -e "Collecting time data\n"
                (time ./aesgcm) &>> time.aesgcm_output.txt      #Collecting time data
                sleep 2
                (time ./aesgcm-small) &>> time.aesgcm-small_output.txt
                sleep 2
        fi

fi

if [ "$1" = "raid5_2" ];
    then
    raid5_2
        if [ "$2" = "perf" ];
            then
                echo -e "Collecting perf stat\n"
                (perf stat -e cycles,r500fa,r5301c2 ./raid5_2) >> perf.stat.raid5_2_output.txt 2>&1
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.raid5_2 ./raid5_2
                sleep 2
                echo -e "Collecting time data\n"
                (time ./raid5_2) &>> time.raid5_2_output.txt
                sleep 2
        fi
fi

if [ "$1" = "raid5_5" ];
    then
    raid5_5
        if [ "$2" = "perf" ];
            then
                echo -e "Collecting perf stat\n"
                (perf stat -e cycles,r500fa,r5301c2 ./raid5_5) >> perf.stat.raid5_5_output.txt 2>&1
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.raid5_5 ./raid5_5
                sleep 2
                echo -e "Collecting time data\n"
                (time ./raid5_5) &>> time.raid5_5_output.txt
                sleep 2
        fi
fi


if [ "$1" = "hash64" ];
    then
    hash64

        if [ "$2" = "perf" ];
           then
                echo -e "Collecting perf stat\n"
                (perf stat -e cycles,r500fa,r5301c2 ./hash64) >> perf.stat.hash64_output.txt 2>&1
                sleep 2
                (perf stat -e cycles,r500fa,r5301c2 ./hash64_dconfig) >> perf.stat.hash64_dconfig_output.txt 2>&1
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.hash64 ./hash64
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.hash64_dconfig ./hash64_dconfig
                sleep 2
                echo -e "Collecting time data\n"
                (time ./hash64) &>> time.hash64_output.txt
                sleep 2
                (time ./hash64_dconfig) &>> time.hash64_dconfig_output.txt
                sleep 2
        fi

fi


if [ "$1" = "jhash" ];
    then
    jhash

        if [ "$2" = "perf" ];
           then
                echo -e "Collecting perf stat\n"
                (perf stat -e cycles,r500fa,r5301c2 ./jhash) >> perf.stat.jhash_output.txt 2>&1
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.jhash ./jhash
                sleep 2
                echo -e "Collecting time data\n"
                (time ./jhash) &>> time.jhash_output.txt
                sleep 2
        fi
fi


if [ "$1" = "stackprotector" ];
    then
    stackprotector

        if [ "$2" = "perf" ];
            then
                echo -e "Collecting perf stat\n"
                (perf stat -e cycles,r500fa,r5301c2 ./stackprotector) >> perf.stat.stackprotector_output.txt 2>&1
                sleep 2
                (perf stat -e cycles,r500fa,r5301c2 ./stackprotector_fno) >> perf.stat.stackprotector_fno_output.txt 2>&1
                sleep 2
                (perf stat -e cycles,r500fa,r5301c2 ./stackprotector_strong) >> perf.stat.stackprotector_strong_output.txt 2>&1
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.stackprotector ./stackprotector
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.stackprotector_fno ./stackprotector_fno
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.stackprotector_strong ./stackprotector_strong
                sleep 2
                echo -e "Collecting time data\n"
                (time ./stackprotector) &>> time.stackprotector_output.txt
                sleep 2
                (time ./stackprotector_fno) &>> time.stackprotector_fno_output.txt
                sleep 2
                (time ./stackprotector_strong) &>> time.stackprotector_strong_output.txt
                sleep 2
        fi
fi


if [ "$1" = "volatile" ];
    then
        volatilelhs
        if [ "$2" = "perf" ];
            then
                echo -e "Collecting perf stat\n"
                (perf stat -e cycles,r500fa,r5301c2 ./volatilelhs) >> perf.stat.volatilelhs.txt 2>&1
                sleep 2
                perf record -e cycles -c 1000000 -o perf.record.volatilelhs ./volatilelhs
                sleep 2
                echo -e "Collecting time data\n"
                (time ./volatilelhs) &>> time.volatilelhs_output.txt
                sleep 2
        fi

fi


if [ "$1" = "bigswitch" ];
    then
        bigswitch
        if [ "$2" = "perf" ];
        then
                echo -e "Collecting perf stat\n"
                COUNT=1
                while [  $COUNT -lt 5 ]; do

                        (perf stat -e cycles,r500fa,r5301c2 ./bigswitch$COUNT) >> perf.stat.bigswitch$COUNT.txt 2>&1
                        sleep 2
                        perf record -e cycles -c 1000000 -o perf.record.bigswitch$COUNT ./bigswitch$COUNT
                        sleep 2
                        echo -e "Collecting time data\n"
                        (time ./bigswitch$COUNT) &>> time.bigswitch$COUNT-output.txt
                        sleep 2
                        COUNT=$[$COUNT+1]
                done
        fi
fi
