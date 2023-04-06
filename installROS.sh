#!/bin/bash
# Install Robot Operating System (ROS) on NVIDIA Development Board
# Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/
# Information from: http://wiki.ros.org/$version/Installation/UbuntuARM

# Red is 1
# Green is 2
# Reset is sgr0

function usage
{
  echo "Usage: ./installROS.sh -p packageName -v versionName [-h]"
  echo "Install ROS Melodic or Noetic"
  echo "-p | --package <packagename>  ROS package to install"
  echo "                              Must include one of the following:"
  echo "                                base"
  echo "                                desktop"
  echo "                                full"
  echo "-v | --version <versionname>  ROS Version to install"
  echo "                              Must match your Ubuntu version."
  echo "                              Select from one of the following:"
  echo "                                melodic"
  echo "                                noetic"
  echo "-h | --help  This message"
}

function shouldInstallPackages
{
  tput setaf 1
  echo "Your package list did not include a package selection"
  echo "or you did not specify a valid version selection"
  tput sgr0 
  echo "Please include one of the following package with -p option:"
  echo "   base"
  echo "   desktop"
  echo "   full"
  echo "and one of the following version with -v option:"
  echo "   melodic"
  echo "   noetic"
  echo ""
  echo "ROS not installed"
}

# Iterate through command line inputs
packages=()
version=()
while [ "$1" != "" ]; do
  case $1 in
    -p | --package )        shift
                            packages+=("$1")
                            ;;
    -v | --version )        shift
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

# Check to see if we have chosen a ROS base kinda thing to install
hasBasePackage=false
for package in "${packages[@]}"; do
  if [[ $package == "base" ]]; then
    hasBasePackage=true
    packages="ros-$version-ros-base"
    break
  elif [[ $package == "desktop" ]]; then
    hasBasePackage=true
    packages="ros-$version-desktop"
    break
  elif [[ $package == "full" ]]; then
    hasBasePackage=true
    packages="ros-$version-desktop-full"
    break
  fi
done
if [ $hasBasePackage == false ] ; then
  shouldInstallPackages
  exit 1
fi
echo "Packages to install: "${packages[@]}

# Let's start installing!

tput setaf 2
echo "Adding repository and source list"
tput sgr0
sudo apt-add-repository universe
sudo apt-add-repository multiverse
sudo apt-add-repository restricted

# Setup sources.lst
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
# If you experience issues connecting to the keyserver, you can try substituting hkp://pgp.mit.edu:80 or hkp://keyserver.ubuntu.com:80 in the previous command.
# Installation
tput setaf 2
echo "Updating apt"
tput sgr0
sudo apt update
tput setaf 2
echo "Installing ROS"
tput sgr0
# This is where you might start to modify the packages being installed, i.e.
# sudo apt install ros-$version-desktop

# Here we loop through any packages passed on the command line
# Install packages ...
for package in "${packages[@]}"; do
  sudo apt install $package -y
done

# Add Individual Packages here
# You can install a specific ROS package (replace underscores with dashes of the package name):
# sudo apt install ros-$version-PACKAGE
# e.g.
# sudo apt install ros-$version-navigation
#
# To find available packages:
# apt-cache search ros-$version
# 
# Initialize rosdep
tput setaf 2
echo "Installing rosdep"
tput sgr0
if [ $version == noetic ] ; then
  sudo apt install python3-rosdep
elif [ $version == melodic ] ; then
  sudo apt install python-rosdep -y
fi
# Initialize rosdep
tput setaf 2
echo "Initializaing rosdep"
tput sgr0
sudo rosdep init
# To find available packages, use:
rosdep update
# Environment Setup - Don't add /opt/ros/$version/setup.bash if it's already in .bashrc
grep -q -F 'source /opt/ros/$version/setup.bash' ~/.bashrc || echo "source /opt/ros/$version/setup.bash" >> ~/.bashrc
source ~/.bashrc
# Install rosinstall
tput setaf 2
echo "Installing rosinstall tools"
tput sgr0
if [ $version == noetic ] ; then
  sudo apt install python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
elif [ $version == melodic ] ; then
  sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential -y
fi
tput setaf 2
echo "Installation complete!"
tput sgr0
