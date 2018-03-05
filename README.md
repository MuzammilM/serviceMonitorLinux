# serviceMonitorLinux
Script that can be used to monitor a running process in ubuntu ; can also be used to restart the same if it stops during execution.

## Install utility via curl
    mkdir -p ~/bin/shellscript && curl -s https://raw.githubusercontent.com/MuzammilM/serviceMonitorLinux/master/serviceMonitor.sh -o ~/bin/shellscript/serviceMonitor.sh 

## Install utility as a cronjob
    mv crontab crontab.backup || mkdir -p ~/logs/cronLogs/ && crontab -l > crontab && echo "* * * * * bash ~/bin/shellscript/serviceMonitor.sh > ~/logs/cronLogs/serviceMonitor.log" >> crontab && crontab crontab
    
## Install utility via curl and setup as a cronjob
    
    mkdir -p ~/bin/shellscript && curl -s https://raw.githubusercontent.com/MuzammilM/serviceMonitorLinux/master/serviceMonitor.sh -o ~/bin/shellscript/serviceMonitor.sh && mv crontab crontab.backup || mkdir -p ~/logs/cronLogs/ && crontab -l > crontab && echo "* * * * * bash ~/bin/shellscript/serviceMonitor.sh > ~/logs/cronLogs/serviceMonitor.log" >> crontab && crontab crontab
