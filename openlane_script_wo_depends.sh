#!/bin/bash

echo "Kindly enter your username (non-root): "
read user_name
echo "Kindly enter the group-name the user is attached to.Execute 'grep $user_name /etc/passwd' to know the group name(without the quotes): "
read group_name
echo "Hi $user_name! Commencing OpenLane build on your system. It should take around 30-45 mins."

echo "=================================="
echo "-----INITIALIZATION-----"
echo "=================================="

ORIGIN_LOC=$(pwd)
sudo apt-get update
sudo apt-get -y upgrade
cd work/tools
sudo apt install software-properties-common
echo "\r" | sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt -y install python3.8
sudo apt-get -y install python3-distutils
sudo apt install python3-tk
sudo apt install ngspice

echo "=================================="
echo "-----INSTALLING DOCKER-----"
echo "=================================="

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
sudo usermod -aG docker $user_name
sudo systemctl stop docker
sudo systemctl start docker
sudo systemctl enable docker

echo "=================================="
echo "-----BUILDING SPEF EXTRACTOR-----"
echo "=================================="
pip install numpy
pip install sympy
pip install matplotlib   
pip install python3-matplotlib
git clone https://github.com/Cloud-V/SPEF_EXTRACTOR/ 

echo "=================================="
echo "----BUILDING OPENLANE----"
echo "=================================="

mkdir openlane_working_dir
cd openlane_working_dir
mkdir pdks
mkdir openlane
export PDK_ROOT=$ORIGIN_LOC/work/tools/openlane_working_dir/pdks
cd $PDK_ROOT
git clone https://github.com/google/skywater-pdk.git
cd skywater-pdk
git checkout 4e5e318e0cc578090e1ae7d6f2cb1ec99f363120
git submodule update --init libraries/sky130_fd_sc_hd/latest
make sky130_fd_sc_hd 
cd $PDK_ROOT
git clone https://github.com/efabless/open_pdks -b rc2
cd open_pdks
make
make install-local
cd ../../
git clone https://github.com/efabless/openlane --branch rc2
cd openlane/docker_build
make merge

cd $ORIGIN_LOC
chown -R $user_name:$group_name work
echo "######CONGRATULATIONS YOU ARE DONE!!########"
exit
exit
