#installing golang
dnf install golang -y

#dispatch as daemon
cp dispatch.service /etc/systemd/system/dispatch.service

#user
useradd roboshop

#data and modules
mkdir /app 
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip 
cd /app 
unzip /tmp/dispatch.zip
cd /app 
go mod init dispatch
go get 
go build

#enable and restart 
systemctl daemon-reload
systemctl enable dispatch 
systemctl start dispatch



