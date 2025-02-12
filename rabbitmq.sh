# installing rabbitmq-server via there repo 
cp rabbitmq.repo /etc/yum.repo.d/rabbitmq.repo
dnf install rabbitmq-server -y

#enable and restart
systemctl enable rabbitmq-server
systemctl restart  rabbitmq-server

#permissions
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

