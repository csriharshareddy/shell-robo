component=shipping
source common.sh
# settinup shipping wit maven
maven_setup
# to load schema we need mysql client
# installing & setting-up mysql-clent
print_head Installig Mysql Client
dnf install mysql -y >> $log_file
exit_status_pirnt $?

print_head Load Schema
mysql -h mysql-dev.mydevopsproject.online -uroot -pRoboShop@1 < /app/db/schema.sql >> $log_file
exit_status_pirnt $?

print_head Load User creation
mysql -h mysql-dev.mydevopsproject.online -uroot -pRoboShop@1 < /app/db/app-user.sql  >> $log_file
exit_status_pirnt $?

print_head Load Master Data
mysql -h mysql-dev.mydevopsproject.online -uroot -pRoboShop@1 < /app/db/master-data.sql >> $log_file
exit_status_pirnt $?




