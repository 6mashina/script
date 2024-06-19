#!/bin/bash

LOCAL_PATH="home/onworks/test.txt"  
REMOTE_USER="root"      
REMOTE_HOST="194.87.94.63"   
REMOTE_PATH="root"
INSTALL_DIR="/script"

mkdir -p $INSTALL_DIR

cat <<EOL > $INSTALL_DIR/send_file.sh

#!/bin/bash
send_file() {
    scp -r /$LOCAL_PATH $REMOTE_USER@$REMOTE_HOST:/$REMOTE_PATH
    if [ \$? -eq 0 ]
    then
        echo "File send sucf"
    else
        echo "Error send file"
    fi
}
send_file
EOL

cat <<EOL > $INSTALL_DIR/check_last_day.sh
#!/bin/bash

SCRIPT_PATH="$INSTALL_DIR/send_file.sh"
TODAY=\$(date +%d)
LAST_DAY=\$(date -d "\$(date +%Y-%m-01) +1 month -1 day" +%d)

if [ "\$TODAY" -eq "\$LAST_DAY" ]
then
    bash \$SCRIPT_PATH
else
    echo "Not last day"
fi
EOL

chmod +x $INSTALL_DIR/send_file.sh
chmod +x $INSTALL_DIR/check_last_day.sh

cat <<EOL > /etc/systemd/system/send_file.service
[Unit]
Description=send imprt file at last month

[Service]
ExecStart=/bin/bash $INSTALL_DIR/check_last_day.sh

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload

systemctl enable send_file.service
systemctl start send_file.service

echo "script install sucsf"