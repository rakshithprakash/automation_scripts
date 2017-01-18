download_and_compile_openssl()
{
wget https://ww}w.openssl.org/source/openssl-1.1.0c.tar.gz || git clone https://github.com/openssl/openssl.git || ( echo "check connection settings" && exit 0 )

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
cp $pmu_location `pwd`
chmod 777 pmu.sh
}

pmu_location=`pwd`

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
perf record -o {$2}.graph --call-graph fp -c 1000000 -- ./openssl speed $1

if [ ! -f pmu.sh ]
then
pmu_not_found

else
chmod 777 pmu.sh
fi
./pmu.sh $1 
