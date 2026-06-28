component=rabbitmq-server
source common.sh
# installing rabbitmq-server via there repo 
print_head Creating RabbitMQ repo file
cp rabbitmq.repo /etc/yum.repo.d/rabbitmq.repo >> $log_file
print_head Installing RabbitMQ
dnf install rabbitmq-server -y >> $log_file

# enableing and restarting rabbitmq
systemd_setup

# adding user for rabbitmq
print_head Creating User for RabbitMQ
rabbitmqctl add_user roboshop roboshop123 >> $log_file
# giveing/setting permissions
print_head Setting  Permissions
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" >> $log_file

