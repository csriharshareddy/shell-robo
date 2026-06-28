component=mysqld
source common.sh
 #install mysql
print_head installing Mysql-Server
dnf install mysql-server -y >> $log_file
# enable and starting mysql 
systemd_setup
#user 
print_head Setting up User for Mysql
mysql_secure_installation --set-root-pass RoboShop@1 >> $log_file


