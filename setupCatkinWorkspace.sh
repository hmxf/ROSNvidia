#!/bin/bash
# Create a Catkin Workspace and setup ROS environment variables

# Red is 1
# Green is 2
# Reset is sgr0

function usage
{
  echo "Usage: ./setupCatkinWorkspace.sh -d installDir -v versionName [-h]"
  echo "Create a Catkin Workspace and setup ROS environment variables"
  echo "-d | --dir <directoryname>  Catkin Workspace to deploy"
  echo "                            If a relative path is provided,"
  echo "                            catkin workspace will be generated under script's directory"
  echo "                            If an absolute path is provided,"
  echo "                            catkin workspace will be generated in the specified directory"
  echo "                            If this option is not used,"
  echo "                            catkin workspace will be generated in the ~/catkin_ws directory"
  echo "-v | --ver <versionname>    ROS Version to specify"
  echo "                            Must match your installed ROS version:"
  echo "                              melodic"
  echo "                              noetic"
  echo "-h | --help  This message"
}
function shouldSpecifyVersion
{
  tput setaf 1
  echo "You did not specify a valid version selection"
  tput sgr0 
  echo "Please specify the ROS version you've installed with -v option:"
  echo "   melodic"
  echo "   noetic"
  echo ""
  echo "Catkin workspace not deployed"
}
installDir=()
version=()
while [ "$1" != "" ]; do
  case $1 in
    -d | --dir )            shift
                            installDir+=("$1")
                            ;;
    -v | --ver )            shift
                            version+=("$1")
                            ;;
    -h | --help )           usage
                            exit
                            ;;
    * )                     usage
                            exit 1
  esac
  shift
done

if [ -z "$version" ] ; then
  shouldSpecifyVersion
  exit 1
fi

source /opt/ros/$version/setup.bash
DEFAULTDIR=~/catkin_ws
if [ ! -z "$installDir" ]; then 
  DEFAULTDIR=$installDir
fi
if [ -e "$DEFAULTDIR" ] ; then
  echo "$DEFAULTDIR already exists; no action taken" 
  exit 1
else 
  echo "Creating Catkin Workspace: $DEFAULTDIR"
fi
echo "$DEFAULTDIR"/src
mkdir -p "$DEFAULTDIR"/src
cd "$DEFAULTDIR"/src
catkin_init_workspace
cd "$DEFAULTDIR"
catkin_make


#setup ROS environment variables
echo "# Setup ROS Environment Variables" >> ~/.bashrc
grep -q -F ' ROS_MASTER_URI' ~/.bashrc ||  echo 'export ROS_MASTER_URI=http://localhost:11311' | tee -a ~/.bashrc
grep -q -F ' ROS_IP' ~/.bashrc ||  echo "export ROS_IP=$(hostname -I)" | tee -a ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc

if [ "${DEFAULTDIR:0:1}" == "/" ] ; then
  echo "The Catkin Workspace has been created to $DEFAULTDIR"
else
  echo "The Catkin Workspace has been created to $(pwd)/$DEFAULTDIR"
fi

echo "Please modify the placeholders for ROS_MASTER_URI and ROS_IP placed into the file ${HOME}/.bashrc"
echo "to suit your environment."
