parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
cd camera/
#get input arg
NUMSLIDES=$1
CAMBINARY=camrunner
if [-f"$CAMBINARY" ];
then
    echo 'already exists'
else
    make
fi
echo 'Launching Camera'
./$CAMBINARY $NUMSLIDES
./launch_matlab.sh
