####################
# Get Dependencies #
####################

sudo apt install -q -y libxml2-dev
sudo apt install -q -y libxslt-dev
sudo apt install -q -y libfreetype6-dev
sudo apt install -q -y pkg-config
sudo apt install -q -y libpng12-dev
sudo python -m pip install pip==9.0.3 --upgrade --force-reinstall
pip install numpy

###############
# Make OpenMC #
###############
git clone https://github.com/mit-crpg/openmc.git
cd openmc
omcPath=$(pwd)
git checkout master
rm -rf build
mkdir build
cd build
# cmake CC=mpicc FC=mpifort HDF5_ROOT=/home/ubuntu/hdf5-1.8.13 -Ddebug=on -Doptimize=on -DCMAKE_INSTALL_PREFIX=/home/ubuntu/openmc/install /home/ubuntu/openmc
# cmake CC=mpicc FC=mpifort PATH=$PATH:/home/ubuntu/openmc/bin -Ddebug=on -Doptimize=on -DCMAKE_INSTALL_PREFIX=/home/ubuntu/openmc/install /home/ubuntu/openmc
CC=mpicc FC=mpifort HDF5_ROOT=$HOME/openmc/bin cmake -DHDF5_PREFER_PARALLEL=on -Ddebug=on -Doptimize=on -DCMAKE_INSTALL_PREFIX=$HOME/openmc/install $HOME/openmc
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
