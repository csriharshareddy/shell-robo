log_file=/tmp/roboshop.log

# removing old log file
rm -f $log_file

systemd_setup() {
    print_head Reloading daemon
    systemctl daemon-reload  >> $log_file
    exit_status_pirnt $?

    print_head enabling $component
    systemctl enable $component >> $log_file
    exit_status_pirnt $?

    print_head resarting $component
    systemctl restart $component >> $log_file
    exit_status_pirnt $?

}

nginx_setup() {
    # Install Nginx
    print_head disableing nginx
    dnf module disable nginx -y >> $log_file
    exit_status_pirnt $?

    
    print_head enableing nginx 24
    dnf module enable nginx:1.24 -y >> $log_file
    exit_status_pirnt $?


    print_head Installing nginx
    dnf install nginx -y >> $log_file
    exit_status_pirnt $?


    # setting up .conf
    print_head settingup nginx configaration  
    cp $component.conf /etc/nginx/nginx.conf >> $log_file
    exit_status_pirnt $?


    # removeing orginal nginx html files
    print_head removing old html data
    rm -rf /usr/share/nginx/html/*  >> $log_file
    exit_status_pirnt $?

    
    # downloading and unziping html data 
    print_head downloading frontend html data
    curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component-v3.zip >> $log_file
    exit_status_pirnt $?

    cd /usr/share/nginx/html  >> $log_file
    pwd >> $log_file

    print_head extracting data
    unzip /tmp/$component.zip >> $log_file
    exit_status_pirnt $?

    
    print_head restarting nginx
    systemctl enable nginx >> $log_file && systemctl restart nginx >> $log_file
    exit_status_pirnt $?

    }

adding_user_and_directory() {
    # adding user 
    print_head Creating user for app
    id roboshop >> $log_file
    if [ $? -ne 0 ]; then
        useradd roboshop >> $log_file
    fi
    exit_status_pirnt $?

    # creating a directory for app
    print_head Creating directory /app
    mkdir /app >> $log_file
    exit_status_pirnt $?

}

component_as_service() {
    # setting component as a service
    print_head Creating service file for $component
    cp $component.service /etc/systemd/system/$component.service >> $log_file
    exit_status_pirnt $?

}

downloading_and_unzip_files() {
    # downloading component data and unziping at /app
    print_head Downloading app data
    curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component-v3.zip  >> $log_file
    exit_status_pirnt $?


    print_head Moving to /app
    cd /app  >> $log_file
    exit_status_pirnt $?


    print_head Extracting app data to /app
    unzip /tmp/$component.zip >> $log_file
    exit_status_pirnt $?

}

nodejs_setup() {
    # instaling nodejs
    print_head Disableing default Nodejs
    dnf module disable nodejs -y >> $log_file
    exit_status_pirnt $?


    print_head Enabeling Nodejs 20
    dnf module enable nodejs:20 -y >> $log_file
    exit_status_pirnt $?


    print_head Installing Nodejs
    dnf install nodejs -y >> $log_file
    exit_status_pirnt $?


    adding_user_and_directory
    component_as_service
    downloading_and_unzip_files

    # downloadin dependencies
    print_head Moving to /app
    cd /app >> $log_file
    exit_status_pirnt $?

    pwd >> $log_file

    print_head Installing Nodejs dependencies
    npm install >> $log_file
    exit_status_pirnt $?


    # enable and restart catalogue as daemon
    systemd_setup
}

python_setup() {
    #installing python3
    print_head Installing Python 3
    dnf install python3 gcc python3-devel -y >> $log_file
    exit_status_pirnt $?


    # payment as daemon
    component_as_service
    #adding user
    adding_user_and_directory
    # downloading component data and unziping at /app
    downloading_and_unzip_files
    # installing pip modules
    print_head moving to /app
    cd /app  >> $log_file
    exit_status_pirnt $?


    print_head Installing python requirmnets with pip3
    pip3 install -r requirements.txt >> $log_file
    exit_status_pirnt $?

} 

golang_setup() {
    #installing golang
    print_head Installing golang
    dnf install golang -y

    # dispatch as daemon
    component_as_service
    # adding user and creating directory 
    adding_user_and_directory
    # downloading component data and unziping at /app
    downloading_and_unzip_files
    # building dispatch
    print_head Moving to /app
    cd /app  >> $log_file

    print_head Installing golang dependencies
    go mod init dispatch >> $log_file
    go get  >> $log_file
    go build >> $log_file   
}

maven_setup() {
    #install maven which is java packaging software
    print_head Installing Maven
    dnf install maven -y >> $log_file
    exit_status_pirnt $?


    # adding user
    adding_user_and_directory
    # shipping as daemon
    component_as_service
    # shipping data
    downloading_and_unzip_files
    # dependencies & build the application
    print_head Moving to /app
    cd /app >> $log_file
    exit_status_pirnt $?
    pwd

    print_head Installing Maven dependencies
    mvn clean package >> $log_file
    mv target/$component-1.0.jar $component.jar  >> $log_file
    exit_status_pirnt $?

    # enableing and restarting shipping
    systemd_setup    
}

print_head() {
    echo -e "\e[35m$*\e[0m"
    echo "************************************" >> $log_file
    echo -e "\e[35m$*\e[0m" >> $log_file
    echo "************************************" >> $log_file
}

exit_status_pirnt() {
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m  >> Exicuted\e[0m"
    else
        echo -e "\e[31m  >> error\e[0m"
        line_number=(cat -n /tmp/roboshop.log | grep "************************************" | tail -n 2 | head -n 1 | awk '{print $1}')
        echo
        echo
        sed -n -e "$line_number,$ p" $log_file 
        exit 1
    fi
}
