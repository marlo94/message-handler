#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    read -p "Log file path: " path
    read -p "Language ID: " languageID
    read -p "Message ID: " messageID
else
    path=$1
    languageID=$2
    messageID=$3
fi
php -r "include 'functions.php'; msg_log('$path','$languageID','$messageID');echo PHP_EOL;"

