component=mongod
source common.sh
# adding mongodb repo and installing it
cp mongodb.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y
#changing mongod.conf to open port to all servers
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
# enable and restart mongod
systemd_setup
