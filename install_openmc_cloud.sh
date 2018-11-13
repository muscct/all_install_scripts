sudo apt install -q -y libxml2-dev libxslt-dev libfreetype6-dev pkg-config libpng12-dev libxml2-dev libxslt-dev libfreetype6-dev pkg-config libpng12-dev git gfortran g++ cmake python-dev python-pip python3-pip openmpi-bin libopenmpi-dev python-tk
/usr/local/bin/pip install numpy
/usr/local/bin/pip install six
/usr/local/bin/pip install scipy
/usr/local/bin/pip install pandas
/usr/local/bin/pip install h5py
/usr/local/bin/pip install matplotlib
/usr/local/bin/pip install uncertainties
/usr/local/bin/pip install lxml
/usr/local/bin/pip install cython
/usr/local/bin/pip install vtk
/usr/local/bin/pip install silomesh
/usr/local/bin/pip install pytest
cd $HOME
git clone https://github.com/mit-crpg/openmc.git
wget https://s3.amazonaws.com/hdf-wordpress-1/wp-content/uploads/manual/HDF5/HDF5_1_10_4/hdf5-1.10.4.tar.gz
tar -xvzf hdf5-1.10.4.tar.gz
cd $HOME/hdf5-1.10.4
sudo CC=mpicc FC=mpifort ./configure --enable-parallel --enable-shared --prefix=$HOME/openmc --with-zlib --enable-fortran
sudo make
sudo make install
cd $HOME/openmc
git checkout master
rm -rf build
mkdir build
cd build
CC=mpicc FC=mpifort HDF5_ROOT=$HOME/openmc/bin cmake -DHDF5_PREFER_PARALLEL=on -Ddebug=on -Doptimize=on -DCMAKE_INSTALL_PREFIX=$HOME/openmc/install $HOME/openmc
make
cp $HOME/openmc/scripts/openmc-get-nndc-data .
cp $HOME/openmc/scripts/openmc-ace-to-hdf5 .
$HOME/openmc/openmc-get-nndc-data