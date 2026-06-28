systemd_setup() {
    print_head Reloading daemon
    systemctl daemon-reload
    print_head enabling $component
    systemctl enable $component
    print_head resarting $component
    systemctl restart $component
}

nginx_setup() {
    # Install Nginx
    print_head disableing nginx
    dnf module disable nginx -y
    print_head installing nginx 24
    dnf module enable nginx:1.24 -y
    dnf install nginx -y
    # setting up .conf
    print_head settingup nginx configaration  
    cp $component.conf /etc/nginx/nginx.conf
    # removeing orginal nginx html files
    print_head removing old html data
    rm -rf /usr/share/nginx/html/* 
    # downloading and unziping html data 
    print_head downloading frontend html data
    curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component-v3.zip
    cd /usr/share/nginx/html 
    print_head extracting data
    unzip /tmp/$component.zip
    print_head restarting nginx
    system enable nginx && systemctl restart nginx   
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
    # enable and restart catalogue as daemon
    systemd_setup
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

maven_setup() {
    #install maven which is java packaging software
    dnf install maven -y
    # adding user
    adding_user_and_directory
    # shipping as daemon
    component_as_service
    # shipping data
    downloading_and_unzip_files
    # dependencies & build the application
    cd /app
    mvn clean package
    mv target/$component-1.0.jar $component.jar 
    # enableing and restarting shipping
    systemd_setup    
}

print_head() {
    echo -e "\e[34m$*\e[0m"
}