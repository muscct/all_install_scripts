########
# hdf5 #
########

# sudo apt install -q -y libhdf5-dev

# szip dependency
wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
tar -xvzf szip-2.1.1.tar.gz
rm -f szip-2.1.1.tar.gz 
cd szip-2.1.1
mkdir /home/ubuntu/szip
./configure --prefix=/home/ubuntu/szip
make
make check
make install
cd ..
rm -rf szip-2.1.1


# zlib only necessary if not compiling with cmake
# wget http://www.zlib.net/zlib-1.2.11.tar.gz
# tar -xvzf zlib-1.2.11.tar.gz

# hdf5
wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.1.tar
tar -xvf hdf5-1.10.1.tar
rm -f hdf5-1.10.1.tar
# https://github.com/HDFGroup/build_hdf5
# https://support.hdfgroup.org/ftp/HDF5/current/src/unpacked/release_docs/INSTALL_parallel
# https://support.hdfgroup.org/HDF5/release/obtainsrc.html