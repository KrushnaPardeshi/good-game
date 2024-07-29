#!/bin/bash

INSTANCE_IP=$1
PRIVATE_KEY=$2
REMOTE_DIR="/home/ubuntu/goodgame"
LOCAL_DIR="scripts"

# check SSH connection
check_ssh() {
    ssh -o StrictHostKeyChecking=no -i $PRIVATE_KEY ubuntu@$INSTANCE_IP "echo 2>&1" && echo "SSH is up" && return 0
    return 1
}

# Retry 
RETRY_COUNT=10
for i in $(seq 1 $RETRY_COUNT); do
    if check_ssh; then
        break
    fi
    echo "SSH not ready, retrying in 10 seconds... ($i/$RETRY_COUNT)"
    sleep 10
done


# Copy dirs and files
rsync -av -e "ssh -i $PRIVATE_KEY" $LOCAL_DIR/backups ubuntu@$INSTANCE_IP:$REMOTE_DIR
scp -i $PRIVATE_KEY $LOCAL_DIR/Dockerfile ubuntu@$INSTANCE_IP:$REMOTE_DIR
scp -i $PRIVATE_KEY $LOCAL_DIR/docker-compose.yml ubuntu@$INSTANCE_IP:$REMOTE_DIR
scp -i $PRIVATE_KEY $LOCAL_DIR/backup_mapping.txt ubuntu@$INSTANCE_IP:$REMOTE_DIR
scp -i $PRIVATE_KEY $LOCAL_DIR/DB-UTILITY.sh ubuntu@$INSTANCE_IP:$REMOTE_DIR

#setting up permissions
ssh -i $PRIVATE_KEY ubuntu@$INSTANCE_IP "sudo chown -R ubuntu:ubuntu $REMOTE_DIR"
ssh -i $PRIVATE_KEY ubuntu@$INSTANCE_IP "sudo chmod +x $REMOTE_DIR/DB-UTILITY.sh"