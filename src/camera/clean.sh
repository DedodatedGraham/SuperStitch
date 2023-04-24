opath=$PWD
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
#rm camrunner 2> /dev/null
rm -r *.jpg 2> /dev/null
