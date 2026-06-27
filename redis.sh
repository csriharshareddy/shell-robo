component=redis
source common.sh
#install redis
dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y 
# setup redis.conf
sed -i -e 'S/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
# enableing and restarting redis
systemd_setup

