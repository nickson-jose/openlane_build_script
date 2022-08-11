#!/bin/bash

echo "Kindly enter your username (non-root): "
read user_name
echo "Kindly enter the group-name the user is attached to.Execute 'grep $user_name /etc/group' to know the group name(without the quotes): "
read group_name
echo "Commencing Openlane build on your system. It should take around 60-90 mins."
echo
echo "=================================="
echo "-----INSTALLING DEPENDENCIES-----"
echo "=================================="
echo
ORIGIN_LOC=$(pwd)
sudo apt-get update
sudo apt-get -y upgrade
mkdir -p work/tools
cd work/tools
sudo apt install -y build-essential python3 python3-venv python3-pip
echo
echo "=================================="
echo "-----INSTALLING DOCKER-----"
echo "=================================="
echo
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get -y install \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
apt-cache madison docker-ce
echo "Please select the required version string from above listed docker repo.The version string is the string in second column of above list"
echo "for example, 5:19.03.12~3-0~ubuntu-bionic"
echo "Enter the required version string: "
read ver_str
sudo apt-get install docker-ce=$ver_str docker-ce-cli=$ver_str containerd.io
sudo usermod -a -G docker $user_name
sudo systemctl stop docker
sudo systemctl start docker
sudo systemctl enable docker
echo
echo "=================================="
echo "----BUILDING OPENLANE----"
echo "=================================="
echo
mkdir openlane_working_dir
cd openlane_working_dir
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane/
make
make test

cd $ORIGIN_LOC
chown -R $user_name:$group_name work
echo
echo "######CONGRATULATIONS YOU ARE DONE!!########"
echo
exit
exit
