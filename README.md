# seng440-arm-automation
### What is this?
I made this for the SENG440 embedded systems class which requires students to run c code on an arm processor. In order to access this processor the code must first be uploaded to a machine on UVic, compiled with an arm processor, transferred over to an arm machine with lftp, and then the user can finally telnet into the machine to execute the program. On top of all this the professor requested that we cleanup the files that we use because the machine does not have much storage. This is a lot of work.

### Why we need this
To manually do all of this the user has to do the following tasks
1. `SCP transfer the files over to the /tmp/ folder on a machine at UVic`
2. `SSH into the machine, move over to /tmp/ and compile the code`
3. `lftp transfer the output executable`
4. `telnet into the arm machine, log in by copying and pasting the provided username and password`
5. `executing the code`
6. `deleted the executable`

To run all of this manually, even with all the commands ready to go, will take at least 3-4 minutes of active work.

However, with this script you simply need to run it with the file you wish to upload and it will handle all of this in about 30 seconds.

If we need to compile and run code for this class 50 times, we can turn 150-200 minutes of mindless work into just running one command and waiting!

### demo
![demo](https://i.imgur.com/vccM7cM.gif)

### Requirements
I've only run this on MacOS, I'm not sure what is available on other UNIX platforms.

You must set up an SSH key to allow the script to connect to the remote servers. Just follow steps 1-3 on the following article https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2

### Usage 

`sh ./run-arm.sh <path to private key> <netlink id> <desired arm user> <-command> <path to c file>`

examples:
1. Run code on arm
- `sh ./run-arm.sh ~/keys/seng440 vernon user2 -c ./helloworld.c`

2. Display assembly
- `sh ./run-arm.sh ~/keys/seng440 vernon user2 -s ./helloworld.c`