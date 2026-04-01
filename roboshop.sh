#!/bin/bash

present=$(pwd)

user_id=$(id -u)

echo "$present working area"

if [ $user_id -ne 0 ]; then

  echo "use root user"
  exit 1
  echo " sudo user "

fi

