#install maven which is java packaging software
dnf install maven -y
#user add
useradd roboshop
#shipping as daemon
cp shipping.service /etc/systemd/system/shipping.service
#shipping data
mkdir /app 
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
cd /app 
unzip /tmp/shipping.zip

# to load schema we need mysql client
#installing & setting-up mysql-clent
dnf install mysql -y 
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/master-data.sql

#enable and restart shipping
systemctl daemon-reload
systemctl enable shipping 
systemctl restart shipping



