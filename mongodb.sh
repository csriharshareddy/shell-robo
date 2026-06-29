component=mongod
source common.sh
# adding mongodb repo and installing it
print_head copying mongodb repo file
cp mongodb.repo /etc/yum.repos.d/mongo.repo >> $log_file
exit_status_pirnt $?

print_head installing MongoDB
dnf install mongodb-org -y >> $log_file
exit_status_pirnt $?

#changing mongod.conf to open port to all servers
print_head Updating MongoDB config file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf >> $log_file
exit_status_pirnt $?

# enable and restart mongod
systemd_setup
