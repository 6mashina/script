# Описание скрипта
## Расположение файлов и установка рабочей директории на системе 
```Bash
LOCAL_PATH=""  
REMOTE_USER=""      
REMOTE_HOST=""   
REMOTE_PATH=""
INSTALL_DIR="/script"
```
**LOCAL_PATH=""** - локальный путь к файлу на системе 

**REMOTE_USER=""** - пользователь на удаленной системе

**REMOTE_HOST=""** - удаленный адрес системы

**REMOTE_PATH=""** - удаленный путь, куда мы хотим, чтобы файл скачался

**INSTALL_DIR="/script** - рабочая директива, где хранятся скрипты, можно изменить расположение, по умолчанию путь "/script"
## Скрипт для отправки файла
```Bash
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
```
## Cкрипт проверяющий последний день месяца
```Bash
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
```

## Установка прав на выполнения скриптов 
```Bash
chmod +x $INSTALL_DIR/send_file.sh
chmod +x $INSTALL_DIR/check_last_day.sh
```
## Создаем службу, которая будет запускать [скрипт](#cкрипт-проверяющий-последний-день-месяца)


cat <<EOL > /etc/systemd/system/send_file.service
[Unit]
Description=send imprt file at last month

[Service]
ExecStart=/bin/bash $INSTALL_DIR/check_last_day.sh

[Install]
WantedBy=multi-user.target
EOL



if bash not work use -> sed -i 's/\r$//' filename
