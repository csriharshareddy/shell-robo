#installing nodejs
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
#adding user
useradd roboshop
mkdir /app
#setting cart as daemon
cp cart.service /etc/systemd/system/cart.service
#data and modules
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
cd /app 
unzip /tmp/cart.zip
cd /app 
npm install 
#enable and restart cart
systemctl daemon-reload
systemctl enable cart 
systemctl restart cart


