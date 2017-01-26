#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    read -p "Language: " languageID
    read -p "Message ID: " messageID
    echo "If you would like to use multiple phone numbers separate them with a comma: xxxxx,xxxxx,xxxxx";
    read -p "Phone Number(s): " messageID

else
    languageID=$1
    messageID=$2
    phones=$3
fi
    php -r "include 'functions.php';msg_sms('$languageID','$messageID',array($phones));"
