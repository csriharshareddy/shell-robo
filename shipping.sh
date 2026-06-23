component=shipping
source common.sh
#install maven which is java packaging software
dnf install maven -y
# adding user
creating_User_And_Directory
# shipping as daemon
component_As_Service
# shipping data
downloading_And_Setting_data
# to load schema we need mysql client
#installing & setting-up mysql-clent
dnf install mysql -y 
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/master-data.sql

# enableing and restarting shipping
systemd_setup


