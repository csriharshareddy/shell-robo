component=redis
source common.sh
#install redis
print_head Disableing default Redis
dnf module disable redis -y >> $log_file
exit_status_pirnt $?

print_head Enableing Redis 7
dnf module enable redis:7 -y >> $log_file
exit_status_pirnt $?

print_head Installing Redis
dnf install redis -y  >> $log_file
exit_status_pirnt $?

# setup redis.conf
print_head Setting up Redis configuration
sed -i -e 'S/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf >> $log_file
exit_status_pirnt $?

# enableing and restarting redis
systemd_setup

