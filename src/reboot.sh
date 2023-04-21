
#Chnage directory if needed
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
sshpass -p machinevision ssh debian@192.168.7.2 -t 'cd /var/lib/cloud9/stageTranslation; ./kill.sh'
