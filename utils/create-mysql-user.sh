#!/bin/bash

# A default root password is set when the mysql-server package is installed, so a new user must be created

clear

echo -n "Username: "
while read db_user; do
  test "$db_user" != "" && break
  echo -n "Username: "
done

echo -n "Password: "
while read db_pwd; do
  test "$db_pwd" != "" && break
  echo -n "Password: "
done

sudo mysql -uroot -p <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_pwd';
CREATE DATABASE IF NOT EXISTS training_data;
GRANT ALL PRIVILEGES ON *.* TO '$db_user'@'localhost';
exit
EOF

sudo service mysql restart

cat >~/.my.cnf <<EOL
[client]
user = $db_user
password = $db_pwd
EOL


exit
