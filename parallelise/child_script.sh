sudo apt update
sudo apt --assume-yes install openmpi-bin libopenmpi-dev
sudo apt-get --assume-yes install nfs-common
mkdir -p $HOME/mpi-shared
sudo mount -t nfs master:~/mpi-shared ~/mpi-shared
echo '#MPI CLUSTER SETUP' | sudo tee --append /etc/fstab
echo 'master:$HOME/mpi-shared $HOME/mpi-shared nfs' | sudo tee --append /etc/fstab