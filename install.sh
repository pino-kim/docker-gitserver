#!/bin/bash 

YOURNAME="$USER"
REPONAME="repositories"
CURRENT_PATH=$(pwd) 
REPO_PATH=/home/$YOURNAME/$REPONAME

# make repositories
if [ ! -d $REPO_PATH ]; then 
	echo "Make [$REPONAME] directory at $REPO_PATH"
	mkdir -p $REPO_PATH
	#chown $YOURNAME:$YOURNAME $REPO_PATH
else
	if [ "$(ls -A $REPO_PATH)" ]; then 
		echo "Your [$REPONAME] directory isn't empty."
		echo "exit Auto installer."
		exit 1
	fi
fi

# run docker run
sudo docker run \
	--name repo_test \
	--restart always \
	-d \
	-p 8800:80 \
	-p 2200:22 \
	-v /home/pino/repositories:/home/git/repositories \
	test
	
# check ssh-key exist
if [ -f /home/$YOURNAME/.ssh/id_rsa.pub ]; then
	echo "id_rsa.pub exist"
	sudo cp /home/$YOURNAME/.ssh/id_rsa.pub /tmp/${YOURNAME}.pub
else
	echo "id_rsa.pub not exist"
        echo "type 'ssh-keygen' on the shell to generate ssh public key."
	echo "exit Auto installer."
	exit 1	
fi

# Initializing the gitotie in the docker container
sudo docker cp /tmp/${YOURNAME}.pub repo_test:/tmp/${YOURNAME}.pub
sudo docker exec -u git repo_test /setup.sh /tmp/${YOURNAME}.pub


