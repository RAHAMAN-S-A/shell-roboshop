#!/bin/bash

present=$(pwd)
LOGS_FOLDER="/var/logs/roboshop/"
LOGS_FILE="/var/logs/roboshop/.$0.logs"
sg_id=sg-00b80ff8ce8c7583c
ami_id=ami-0220d79f3f480ecf5

user_id=$(id -u)

echo "$present working area"

if [ $user_id -ne 0 ]; then

  echo "use root user"
  exit 1
  echo " sudo user "
  fi

mkdir -p $LOGS_FOLDER



log(){
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOGS_FILE
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2 ... FAILURE" | tee -a $LOGS_FILE
        exit 1
    else
        echo "$2 ... SUCCESS" | tee -a $LOGS_FILE
     

 fi
}


dnf install nginx -y
VALIDATE $? "installing nginx" | tee -a $LOGS_FILE

dnf install mysql -y
VALIDATE $? "Installing Mysql" | tee -a $LOGS_FILE


dnf install nodejs -y
VALIDATE $? "Installing nodejs" | tee -a $LOGS_FILE

   echo " already installed "



for package in $@ # sudo sh 14-loops.sh nginx mysql nodejs
do
    dnf list installed $package &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        echo "$package not installed, installing now"
        dnf install $package -y &>>$LOGS_FILE
        #VALIDATE $? "$package installation"
    else
        echo -e "$package already installed ... $Y SKIPPING $N"
    fi
done


aws ec2 run-instances \
--image-id $ami_id \
--instance-type t3.micro \
--security-group-ids $sg_id \
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]"
