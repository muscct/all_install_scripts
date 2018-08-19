#####################
# pull dependencies #
#####################

sudo apt-get update
sudo apt-get install -q -y --reinstall build-essential
sudo apt install -q -y git
sudo apt install -q -y gfortran
sudo apt install -q -y g++
sudo apt install -q -y cmake
sudo apt install -q -y libxml2-dev
sudo apt install -q -y libxslt-dev
sudo apt install -q -y python-dev
sudo apt install -q -y libfreetype6-dev
sudo apt install -q -y pkg-config
sudo apt install -q -y libpng12-dev
sudo apt install -q -y python-pip
# alias python=python3
sudo python -m pip install pip==9.0.3 --upgrade --force-reinstall
pip install numpy

#############
# intel mpi #
#############

wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13063/l_mpi_2018.3.222.tgz
tar -xvzf l_mpi_2018.3.222.tgz 
cd l_mpi_2018.3.222
sudo bash install.sh
# find / -name "mpivars*"
source /opt/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/bin/mpivars.sh
cd ..

########
# hdf5 #
########

# sudo apt install -q -y libhdf5-dev

# szip dependency
wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
tar -xvzf szip-2.1.1.tar.gz
cd szip-2.1
mkdir /home/ubuntu/szip
./configure --prefix=/home/ubuntu/szip
make
make check
make install
cd ..

# zlib only necessary if not compiling with cmake
# wget http://www.zlib.net/zlib-1.2.11.tar.gz
# tar -xvzf zlib-1.2.11.tar.gz

# hdf5
wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.1.tar
tar -xvf hdf5-1.10.1.tar
# https://github.com/HDFGroup/build_hdf5
# https://support.hdfgroup.org/ftp/HDF5/current/src/unpacked/release_docs/INSTALL_parallel
# https://support.hdfgroup.org/HDF5/release/obtainsrc.html


git clone https://github.com/mit-crpg/openmc.git
cd openmc
omcPath=$(pwd)
git checkout master
mkdir build
cd build
export FC=mpiifort
export CC=mpicc
cmake -Ddebug=on -Doptimize=on -DCMAKE_INSTALL_PREFIX=$omcPath/install .. 
make
# mkdir -p $omcPath/install/lib/python2.7/site-packages
# mkdir $omcPath/backup
# cp /usr/bin/pip $omcPath/backup
# replace main.py as per https://github.com/pypa/pip/issues/5240
# sed -r 's/from pip import main/from pip._internal import main/g' /usr/bin/pip > /usr/bin/pip

# make install


# export FC=mpif90
# export CC=mpicc
# export HDF5_ROOT=/opt/hdf5/1.8.15
# cmake /path/to/openmc
# FC=mpif90 CC=mpicc cmake $omcPath


# HDF5 parallel cmake option
# FC=mpifort.mpich cmake -DHDF5_PREFER_PARALLEL=on ..

# HDF5
# FC=mpifort ./configure --enable-fortran --enable-parallel

# distributed mem
# sudo apt install mpich libmpich-dev
# sudo apt install openmpi-bin libopenmpi-dev
