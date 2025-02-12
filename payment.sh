#installing python3
dnf install python3 gcc python3-devel -y
#payment as daemon
cp payment.service /etc/systemd/system/payment.service
#adding user
useradd roboshop
#data and modules
mkdir /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip 
cd /app 
unzip /tmp/payment.zip
cd /app 
pip3 install -r requirements.txt
#enable and restaring
systemctl daemon-reload
systemctl enable payment 
systemctl restart payment

