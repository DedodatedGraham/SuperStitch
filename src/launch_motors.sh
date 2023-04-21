#Chnage directory if needed
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
#Get input args
this_root=$1
micro_controller=$2
echo "Launching Motors"
<<<<<<< HEAD
sshpass -p machinevision ssh debian@192.168.7.2 -t 'source ~/.bashrc;cd /var/lib/cloud9/stageTranslation;./run_motors.sh'
=======
$micro_controller 'cd ~/var/lib/cloud9/stageTranslation; ./run_motors.sh'
>>>>>>> 996fd49ba3196d25185ec148fa62fdedad1ff83a
