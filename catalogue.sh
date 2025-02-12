# install .nodejs
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
# adding mongodb repo and installing it
cp mongodb.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
# adding a user
useradd roboshop
mkdir /app
# setting catalouge as a service
cp catalogue.service /etc/systemd/system/catalogue.service
# catalouge data and installing dependencies
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip
cd /app
npm install
# enable and restart catalogue as daemon
systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

#data into mongodb 
mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js