#install mysql
dnf install mysql-server -y
#enable and start mysql 
systemctl enable mysqld
systemctl restart mysqld 
#user 
mysql_secure_installation --set-root-pass RoboShop@1


