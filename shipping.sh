component=shipping
source common.sh
#install maven which is java packaging software
dnf install maven -y
# adding user
adding_user_and_directory
# shipping as daemon
component_as_service
# shipping data
downloading_and_unzip_files
# to load schema we need mysql client
#installing & setting-up mysql-clent
dnf install mysql -y 
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/master-data.sql

# enableing and restarting shipping
systemd_setup


