systemd_setup() {
    systemctl daemon-reload
    systemctl enable $component
    systemctl restart $component
}

nginx_setup() {
    # Install Nginx
    dnf module disable nginx -y
    dnf module enable nginx:1.24 -y
    dnf install nginx -y
    # setting up .conf 
    cp $component.conf /etc/nginx/nginx.conf
    # removeing orginal nginx html files
    rm -rf /usr/share/nginx/html/* 
    # downloading and unziping html data 
    curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component-v3.zip
    cd /usr/share/nginx/html 
    unzip /tmp/$component.zip
    systemctl enable nginx && systemctl restart nginx
}

adding_user_and_directory() {
    # adding user 
    useradd roboshop
    # creating a directory for app
    mkdir /app
}

component_as_service() {
    # setting component as a service
    cp $component.service /etc/systemd/system/$component.service
}

downloading_and_unzip_files() {
    # downloading component data and unziping at /app
    curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component-v3.zip 
    cd /app 
    unzip /tmp/$component.zip
}

nodejs_setup() {
    # instaling nodejs
    dnf module disable nodejs -y
    dnf module enable nodejs:20 -y
    dnf install nodejs -y
    adding_user_and_directory
    component_as_service
    downloading_and_unzip_files
    # downloadin dependencies
    cd /app
    npm install

}

python_setup() {
    #installing python3
    dnf install python3 gcc python3-devel -y
    # payment as daemon
    component_as_service
    #adding user
    adding_user_and_directory
    # downloading component data and unziping at /app
    downloading_and_unzip_files
    # installing pip modules
    cd /app 
    pip3 install -r requirements.txt
} 

golang_setup() {
    #installing golang
    dnf install golang -y

    # dispatch as daemon
    component_as_service
    # adding user and creating directory 
    adding_user_and_directory
    # downloading component data and unziping at /app
    downloading_and_unzip_files
    # building dispatch
    cd /app 
    go mod init dispatch
    go get 
    go build    
}
