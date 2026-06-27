component=catalogue
source common.sh

# adding mongodb repo and installing it
cp mongodb.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
# settig up nodejs
nodejs_setup
#data into mongodb 
mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js