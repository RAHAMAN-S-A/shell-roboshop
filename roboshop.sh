#!/bin/bash

present=$(pwd)
LOGS_FOLDER="/var/logs/roboshop/"
LOGS_FILE="/var/logs/roboshop/.$0.logs"

user_id=$(id -u)

echo "$present working area"

if [ $user_id -ne 0 ]; then

  echo "use root user"
  exit 1
  echo " sudo user "
mkdir -p $LOGS_FOLDER

fi
log(){
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOGS_FILE
}

valadiate(){
    if [ $1 -ne 0 ]; then
        echo "$2 ... FAILURE"
        exit 1
    else
        echo "$2 ... SUCCESS"
    fi
}


dnf install nginx -y
valadaiate $? " installing nginx "

dnf install mysql -y
VALIDATE $? "Installing Mysql"

dnf install nodejs -y
VALIDATE $? "Installing nodejs"