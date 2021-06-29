#!/bin/bash

echo -e "Enter your username \e[7m(non-root)\e[27m: "
read user_name
echo -e "Enter the group-name the user is attached to.Execute \e[7mgrep $user_name /etc/group \e[27mto know the group name(without the quotes): "
read group_name
echo
read -p "Hi $user_name, Have you copied openlane_script_wo_depends.sh to ~/vsdflow/ and currently in vsdflow directory? [y/n]: " my_resp
echo
if [ "${my_resp,,}" != "y" ]
    then 
        echo
        echo "Copy openlane_script_wo_depends.sh to ~/vsdflow/ & execute it from there. Exiting now.."
        echo
        exit
else
echo "Commencing Openlane build on your system. It should take around 30-45 mins."
echo
echo "=================================="
echo "-----INITIALIZATION-----"
echo "=================================="
echo
ORIGIN_LOC=$(pwd)
sudo apt-get update
sudo apt-get -y upgrade
cd work/tools
sudo apt install software-properties-common
echo "\r" | sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt -y install python3.8
sudo apt-get -y install python3-distutils
sudo apt -y install python3-tk
sudo apt install ngspice
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
echo
echo "Select the required version string from above listed docker repo.The version string is the string in second column of above list"
echo
echo "For example,5:19.03.12~3-0~ubuntu-bionic"
echo
echo -e "\e[7mEnter the required version string\e[27m: "
read ver_str
sudo apt-get install docker-ce=$ver_str docker-ce-cli=$ver_str containerd.io
sudo usermod -aG docker $user_name
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
mkdir pdks
export PDK_ROOT=$ORIGIN_LOC/work/tools/openlane_working_dir/pdks
git clone https://github.com/efabless/openlane.git
cd openlane
make openlane
make pdk
cd $ORIGIN_LOC
chown -R $user_name:$group_name work
echo
echo "######CONGRATULATIONS YOU ARE DONE!!########"
echo
fi
exit
exit
