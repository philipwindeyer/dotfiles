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

sudo mysql -u root -h localhost <<EOF
CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pwd';
flush privileges
exit
EOF

sudo service mysql restart

exit
