mkdir -p $HOME/openmc

cd $HOME/openmc

wget https://s3.amazonaws.com/hdf-wordpress-1/wp-content/uploads/manual/HDF5/HDF5_1_10_4/hdf5-1.10.4.tar.gz
tar -xvzf hdf5-1.10.4.tar.gz
rm hdf5-1.10.4.tar.gz
cd hdf5-1.10.4
sudo CC=mpicc FC=mpifort ./configure --enable-parallel --prefix=/home/ubuntu/openmc --with-zlib --enable-shared --enable-fortran
sudo make
sudo make install
cd ..