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
