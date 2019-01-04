#Script to monitor running services
#Author Muzammil
#Last Updated on 20190104
#!/bin/sh

COLOR='\033[0;31m'
reset=`tput sgr0`

if [ ! -f "/home/"$USER"/config/shellscript/serviceProperties.properties" ]; then
        echo -e "${COLOR}Property file not found. Please create one called serviceProperties.properties within ~/config/shellscript ${reset}"
        echo -e "${COLOR}Format :${reset}"
        curl https://raw.githubusercontent.com/MuzammilM/serviceMonitorLinux/master/serviceProperties.properties
        exit
fi

if [ ! -d "/home/"$USER"/logs/shellLogs/" ]; then
        mkdir -p ~/logs/shellLogs/
        exit
fi
generalLog='/home/'$USER'/logs/shellLogs/serviceLog.log'
echo `date +'%Y-%m-%dT%H:%M:%SZ'` > $generalLog
while IFS='' read -r serviceProp || [[ -n "$serviceProp" ]]; do
eval $serviceProp
serviceLog='/home/'$USER'/logs/shellLogs/'$name'Log.log'
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" #>> $generalLog
echo "Check Against = "$check #>> $generalLog
echo "Command = "$cmd #>> $generalLog
echo "Process = "$process #>> $generalLog
echo "Name = "$name #>> $generalLog
psValue="ps"
if [ "$process" == "$psValue" ]
  then
    cnt=`ps aux | grep "$check" |grep -v grep | wc -l`
    echo "using ps"
    echo "count is "$cnt
else
  cnt=`jps -l | grep "$check" | wc -l`
  echo "using jps"
  echo $cnt
fi
if [ $cnt = 0 ]
  then
    nohup $cmd > /dev/null &
    echo $name" Process Not running" >> $serviceLog
    #Notification module to send SMS
    bash ~/bin/shellscript/slackBotMachinePulse.sh sre $name restarted in $HOSTNAME - $ENV
    bash bin/shellscript/slackBotMachinePulse.sh sre Available disk space $c in $HOSTNAME - $ENV
    c=`df -h | head -n 2 | tail -n 1 | awk '{print $4}'`
    echo `date +'%Y-%m-%dT%H:%M:%SZ'` $name 'started' >> $serviceLog
    continue
elif [ $cnt != 0 ]
  then
    echo $name'Process running '`date +'%Y-%m-%dT%H:%M:%SZ'`  >> $serviceLog
fi
echo "****************************************************************************************" >> $generalLog

done < ~/config/shellscript/serviceProperties.properties
