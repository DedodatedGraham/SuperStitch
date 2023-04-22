clear
#Here we run our program, controlling the microcontroller, camera, and stitching and linking them all.
#First setting up our path
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
code_path="$PWD/.."
#Establish a connection with microcontroller:
micro_controller="sshpass -p machinevision ssh debian@192.168.7.2"

#Next we will start all individual scipts to make the controller work
##BAKCGROUND PROCESSES
bash launch_gui.sh $code_path "$micro_controller"
bash launch_motors.sh  $code_path "$micro_controller"

##Might do this from beaglebone gui to this computer though beaglebone
