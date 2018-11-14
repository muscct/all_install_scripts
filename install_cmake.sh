cd $HOME
wget https://cmake.org/files/v3.12/cmake-3.12.4-Linux-x86_64.sh
chmod +x cmake-3.12.4-Linux-x86_64.sh
sudo apt remove cmake
sudo bash cmake-3.12.4-Linux-x86_64.sh
sudo ln -s /opt/cmake-3.12.4-Linux-x86_64/bin/* /usr/local/bin