parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
cd camera/
#get input args
NUMSLIDES=$1
IMGNAME=$2
#mkdir ../../output/$2/
CAMBINARY=runCam.exe
#if [-f"$CAMBINARY" ];
#then
#    echo 'already exists'
#else
#    make
#fi
echo 'Launching Camera'
echo "./$CAMBINARY $NUMSLIDES"
wine "start $CAMBINARY $NUMSLIDES"
echo "Launching MATLAB with: $IMGNAME"
#./launch_matlab.sh $IMGNAME
