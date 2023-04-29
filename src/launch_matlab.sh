#Change directory if needed
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
#Get input args
this_root=$1
echo "successfully launched matlab script"
