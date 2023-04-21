#Chnage directory if needed
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
#Get input args
this_root=$1
micro_controller=$2
echo "Launching Motors"
$micro_controller 'cd ~/var/lib/cloud9/stageTranslation; ./run_motors.sh'
