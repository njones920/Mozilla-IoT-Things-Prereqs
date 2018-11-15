#!/bin/bash

## Fedora Install 
if cat /etc/fedora-release | grep 2* 
then
   echo "Fedora"
   sudo dnf --refresh upgrade   
   sudo dnf group install "C Development Tools and Libraries"
   sudo dnf install -y pkgconfig curl boost-python-devel boost-devel bluez-libs-devel glib2-devel libudev-devel libusb1-devel autoconf pkgconfig libpng-devel git
   sudo firewall-cmd --zone=public --add-port=4443/tcp --permanent
   sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
   sudo firewall-cmd --zone=public --add-port=5353/udp --permanent 

## ARM packages specific
## Ubuntu Install 16+
elif cat /etc/lsb-release | grep 16.*
then
    echo "Ubuntu"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y pkg-config curl libboost-python-dev libboost-thread-dev libbluetooth-dev libglib2.0-dev libusb-1.0-0-dev libudev-dev autoconf libpng-dev git build-essential
    
else
    echo "For future use"
fi

# install Node

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
. ~/.bashrc
nvm install
nvm use
nvm alias default $(node -v)

# set bluetooth permissions

sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
sudo setcap cap_net_raw+eip $(eval readlink -f `which python3`)

# build and install openzwave

cd
git clone https://github.com/OpenZWave/open-zwave.git
cd open-zwave
CFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 make && sudo CFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 make install
sudo ldconfig
export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
sudo ldconfig

# Download and Build Gateway

cd
git clone https://github.com/mozilla-iot/gateway.git
cd gateway
yarn

## start web server - if you want to add your own key please follow alternate directions

echo please Load http://localhost:8080 in your web browser (or use the server's IP address if loading remotely). Then follow the instructions on the web page to set up domain and register. Once this is done you can load https://localhost:4443 in your web browser (or use the server's IP address if loading remotely).

npm start
