#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\E[31M"
G="\E[32M"
N="\E[0M"

VALIDATE(){
 if [ $1 -ne 0 ]
 then
    echo "$2... $R FAILURE $N"
    exit 1
else 
    echo "$2... $G SUCCESS $N"
fi
}                          

if [ $USERID -ne 0 ]
then 
    echo "Please run this script with root access."
    exit 1 # manually exist if error comes.
else
   echo "You are a super user."
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl start mysqld -y &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"

mysql_secure_installation --set-root-pass ExpenseApp@1 -y &>>$LOGFILE
VALIDATE $? "Setting up root password"
