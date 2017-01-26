#!/usr/bin/env bash
echo "---------------------------------------"
echo " Message Handler installation "
echo "---------------------------------------"
if php -f "sql/compiler.php"; then
    echo "=> SQL successfully compiled"
    echo "---------------------------------------"
else
    echo "=> SQL successfully failed"
    echo "---------------------------------------"
fi
if cp config/config-template.json config/config.json; then
    echo "=> Config file successfully created"
    echo "---------------------------------------"
else
    echo "=> Config file creation failed"
    echo "---------------------------------------"
fi
read -p " Desired Database: " database
read -p " MySQL Username: " username
database="DROP DATABASE IF EXISTS $database;CREATE DATABASE IF NOT EXISTS $database;USE $database;"
if mysql -u $username -p -e "$database source sql/compiled.sql;"; then
    echo "---------------------------------------"
    echo "=> Installation complete";
    echo "---------------------------------------"
else
    echo "---------------------------------------"
    echo "=> Installation failed";
    echo "---------------------------------------"
fi
