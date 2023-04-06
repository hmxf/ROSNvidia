# ROS NVIDIA
Install Robot Operating System (ROS) on NVIDIA Development Board

These scripts will install Robot Operating System (ROS) on the NVIDIA Development Board.

Since the [Origin Repo](https://github.com/jetsonhacks/installROSXavier) didn't update for a long time and L4T's Linux is updated to Ubuntu 20.04 rather than 18.04, so ROS version is also changed from Melodic to Noetic.

If you need Preempt-RT Kernel for your NVIDIA Development Board, [this Repo](https://github.com/hmxf/RTJetson) may help a little.

There are two scripts:

<strong>installROS.sh</strong>

Usage:

<pre>
Usage: ./installROS.sh -p packageName -v versionName [-h]
  -p | --package <packagename>  ROS package to install
                                Select from one of the following:
                                  base
                                  desktop
                                  full
  -v | --version <versionname>  ROS Version to install
                                Must match your Ubuntu version.
                                Select from one of the following:
                                  melodic
                                  noetic
  -h | --help      This message
</pre>

Since the script needs to support multiple ROS version options, so the -p option no longer supports specifying the full package name, but only allows you to choose between the three installation methods of ROS-Base, Desktop Install and Desktop-Full Install.

Independent packages need to be installed by yourself.

Example:

$ ./installROS.sh -p full -v noetic

This script installs a baseline ROS environment. There are several tasks:

<ul>
<li>Enable repositories universe, multiverse, and restricted</li>
<li>Adds the ROS sources list</li>
<li>Sets the needed keys</li>
<li>Install specified ROS packages</li>
<li>Initializes rosdep</li>
</ul>

<strong>setupCatkinWorkspace.sh</strong>

Usage:

<pre>
Usage: ./setupCatkinWorkspace.sh -d installDir -v installVer [-h]
  -d | --dir <directoryname>    Catkin Workspace to deploy
                                If a relative path is provided,
                                catkin workspace will be generated under script's directory.
                                If an absolute path is provided,
                                catkin workspace will be generated in the specified directory.
                                If this option is not used,
                                catkin workspace will be generated in the ~/catkin_ws directory.
  -v | --ver <versionname>    ROS Version to specify
                                Must match your installed ROS version:
                                  melodic
                                  noetic
  -h | --help    This message
</pre>

Example:

$ ./setupCatkinWorkspace.sh -d ~/catkin_ws -v noetic

This script creates an empty catkin workspace and sets up some ROS environment variables. There are several tasks:

<ul>
<li>Create catkin workspace</li>
<li>Initialize workspace</li>
<li>Set environment variables</li>
</ul>
