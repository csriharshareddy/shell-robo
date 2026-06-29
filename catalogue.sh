component=catalogue
source common.sh

# adding mongodb repo and installing it
print_head Creating MongoDB repo 
cp mongodb.repo /etc/yum.repos.d/mongo.repo >> $log_file
exit_status_pirnt $?

print_head Installing MongoDB
dnf install mongodb-mongosh -y >> $log_file
exit_status_pirnt $?

# settig up nodejs
nodejs_setup
#data into mongodb 
print_head Load Master Data
mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js >> $log_file 
exit_status_pirnt $?
