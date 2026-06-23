component=rabbitmq-server
source common.sh
# installing rabbitmq-server via there repo 
cp rabbitmq.repo /etc/yum.repo.d/rabbitmq.repo
dnf install rabbitmq-server -y

# enableing and restarting rabbitmq
systemd_setup

# adding user for rabbitmq
rabbitmqctl add_user roboshop roboshop123
# giveing/setting permissions
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

