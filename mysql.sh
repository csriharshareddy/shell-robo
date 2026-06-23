component=mysqld
source common.sh
 #install mysql
dnf install mysql-server -y
# enable and starting mysql 
systemd_setup
#user 
mysql_secure_installation --set-root-pass RoboShop@1


