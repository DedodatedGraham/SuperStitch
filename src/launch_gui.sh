#Chnage directory if needed
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
#Get input args
this_root=$1
micro_controller=$2
echo "Launching GUI"
#sshpass -p machinevision ssh debian@192.168.7.2 "source ~/.bashrc;$NODE_PATH"
sshpass -p machinevision ssh debian@192.168.7.2 -t 'source ~/.bashrc; source ~/.profile; $NODE_PATH ;cd /var/lib/cloud9/stageTranslation;./run_gui.sh' &
xdg-open http://192.168.7.2:8085/machinevision.html
