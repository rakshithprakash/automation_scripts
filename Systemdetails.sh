#!/bin/bash


echo -e "\n******************************************************************************"
date=`date`
echo -e "DATE : "$date
echo -e "******************************************************************************\n"

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

system_details
