#!/bin/bash

# Get all flags
while getopts h:p: flag
do
    case "${flag}" in
        h) hostname=${OPTARG};;
		p) password=${OPTARG};;
    esac
done

if [ -n "$hostname" ]; then
    echo "Hostname: $hostname"
else
    echo "Error, no hostname provided using '-h'."
    exit 0
fi
if [ -n "$password" ]; then
    echo "Password: ***********"
else
    echo "Error, no password provided using '-p'."
    exit 0
fi

apt-get -y update
apt-get -y upgrade

apt -y install vim


echo "set nocompatible" >> ~/.vimrc


echo "Changing password"
##### Change Password #####
echo "pi:$password" | chpasswd


##### Change the hostname of the box######
currentHostname=$(cat /etc/hostname)

# Display the current hostname
echo "The current hostname is $currentHostname"

# Change the hostname
hostnamectl set-hostname $hostname
hostname $hostname

# Change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/$currentHostname/$hostname/g" /etc/hosts
sudo sed -i "s/$currentHostname/$hostname/g" /etc/hostname

# Display new hostname
echo "The new hostname is $hostname"


##set up cloud features
echo " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" >> /boot/cmdline.txt


##### Install Docker #####
curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker pi


##### Install K3s ######
export K3S_URL="https://192.168.86.189:6443"
export K3S_TOKEN=”K10d71de45fdfcb53498841a01e636eea5d214a4c8ccc21a2d2f9d9399ff2d80d56::server:5ae70d989cdf8c193770ca93baffc9d5”
curl -sfL https://get.k3s.io | sh -

sudo reboot -h now