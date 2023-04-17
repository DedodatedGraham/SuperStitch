#Chnage directory if needed
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
#Get input args
this_root=$1
micro_controller=$2
echo "Launching GUI"
$micro_controller 'cd ~/var/lib/cloud9/stageTranslation;./rungui'
open http://192.168.7.2:8085/machinevision.html
