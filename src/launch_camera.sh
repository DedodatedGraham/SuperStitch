parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

cd camera/
CAMBINARY=camrunner
if [-f"$CAMBINARY" ];
then
    echo 'already exists'
else
    make
fi
./$CAMBINARY
