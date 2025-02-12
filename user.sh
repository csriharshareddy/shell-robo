# install .nodejs
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
# adding user 
useradd roboshop
mkdir /app
#creating a systemd file to run user as deamon
cp user.service /etc/systemd/system/user.service
# adding data and install dependencies(modules)
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip 
cd /app 
unzip /tmp/user.zip
cd /app 
npm install 

# enabeling and restarting user
systemctl daemon-reload
systemctl enable user 
systemctl restart user
