#!/bin/bash
mysql_user=root
mysql_password=passw0rd
mysql_host=127.0.0.1
mysql_port=3306
db_name=mysql

mysql -u $mysql_user -p"$mysql_password" -h $mysql_host -P mysql_port $db_name -e "select * from time_zone limit 1;"
