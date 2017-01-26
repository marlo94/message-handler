#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    read -p "Language: " languageID
    read -p "Message ID: " messageID
    read -p "Timestamp: [Y/n] " timestamp
else
    languageID=$1
    messageID=$2
    timestamp=$3
fi
case "$timestamp" in
    [yY][eE][sS]|[yY])
        php -r "include 'functions.php';msg_twitter('$languageID','$messageID',true);"
        ;;
    *)
        php -r "include 'functions.php';msg_twitter('$languageID','$messageID',false);"
        ;;
esac