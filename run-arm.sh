#!/bin/bash

keypath=$1
username=$2
armuser=$3
mode=$4
directory=$5
filename=$6

# Make sure you end your commands with a semicolon
commands=()
commands+="cd /tmp/${username};"

if [[ "$mode" == "-c" ]]; then
    commands+="echo 'compiling...';"
    commands+="make;" # Runs a makefile, change this to suit your compilation method

    commands+="chmod 777 ./rsa_128;"
    commands+="echo 'transferring to arm...';"
    commands+="lftp -c \"open -u ${armuser},q6coHjd7P ${armuser}@arm; put -O . ./rsa_128\";"
    commands+="eval \"{ sleep 1; echo ${armuser};\
        sleep 1; echo q6coHjd7P;\
        echo 'chmod 777 rsa_128';\
        echo './rsa_128';\
        sleep 1; }\"\
        | telnet arm;"

    # GProf code profiling
    commands+="echo 'preparing code profiling results...';"
    commands+="lftp -c \"open -u ${armuser},q6coHjd7P ${armuser}@arm; get ./gmon.out -o .\";"
    commands+="gprof rsa_128 gmon.out;"

elif [[ "$mode" == "-s" ]]; then
    commands+="arm-linux-gcc -static -S -o ${username} $filename;"
    commands+="cat ${username};"
fi

# NOTE:
# If you want to take a look at the code manually get rid of the rm call after the sleep 1
# and comment out the rm call on the commands append below

# cleanup
commands+="echo 'cleanup';"
commands+="cd ..; rm -Rf ${username};"

if [[ "$mode" == "-c" ]]; then
    commands+="eval \"{ sleep 1; echo ${armuser};\
            sleep 1; echo q6coHjd7P;\
            sleep 1; echo 'rm -f rsa_128 gmon.out'; sleep 1; }\"\
            | telnet arm;"
fi

echo "$commands"

# Main Function
echo "Making folder under /tmp/";
ssh -i $keypath $username@seng440.ece.uvic.ca "cd /tmp; mkdir ${username}";
echo "Transferring C code from local machine to remote";
scp -i $keypath ${directory}/*.{c,h} ${directory}/Makefile $username@seng440.ece.uvic.ca:/tmp/$username;
echo "SSH into remote machine";
ssh -i $keypath $username@seng440.ece.uvic.ca "$commands";