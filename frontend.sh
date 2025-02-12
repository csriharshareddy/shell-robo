# Install Nginx
dnf module disable nginx -y
dnf module enable nginx:1.24 -y
dnf install nginx -y
# setting up .conf 
cp frontend.conf /etc/nginx/nginx.conf
# removeing orginal nginx html files
rm -rf /usr/share/nginx/html/* 
# downloading and unziping html data 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
systemctl enable mongod 
systemctl start mongod  nginx
systemctl enable nginx && systemctl restart nginx