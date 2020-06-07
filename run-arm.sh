#!/bin/bash

keypath=$1
username=$2
armuser=$3
mode=$4
filename=$5

# Make sure you end your commands with a semicolon
commands=()
commands+="cd /tmp/${username};"

if [[ "$mode" == "-c" ]]; then
    commands+="echo 'compiling...';"
    commands+="arm-linux-gcc -static -o ${username} $filename;"
    commands+="echo 'transferring to arm...';"
    commands+="lftp -c \"open -u ${armuser},q6coHjd7P user1@arm; put -O . ./${username}\";"
    commands+="eval \"{ sleep 1; echo ${armuser};\
        sleep 1; echo q6coHjd7P;\
        echo 'chmod 777 ${username}';\
        echo './${username}';\
        sleep 1; echo 'rm -f ${username}'; }\"\
        | telnet arm;"
elif [[ "$mode" == "-s" ]]; then
    commands+="arm-linux-gcc -static -S -o ${username} $filename;"
    commands+="cat ${username};"
fi

#cleanup
commands+="echo 'cleanup';"
commands+="cd ..; rm -Rf ${username};"

echo "$commands"

echo "Making folder under /tmp/";
ssh -i $keypath $username@seng440.ece.uvic.ca "cd /tmp; mkdir ${username}";
echo "Transferring C code from local machine to remote";
scp -i $keypath $filename $username@seng440.ece.uvic.ca:/tmp/$username;
echo "SSH into remote machine";
ssh -i $keypath $username@seng440.ece.uvic.ca "$commands";