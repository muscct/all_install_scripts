set -e # abort script if any commands fail.
set -o pipefail # pipe exit code of chained commands to rightmost.

#####################
# Make Dependencies #
#####################

# sudo apt install -q -y libhdf5-dev

# szip dependency
if [[ ! -d szip-2.1.1 ]]; then
    if [[ ! -a szip-2.1.1.tar.gz ]]; then
        wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
    fi
    tar -xvzf szip-2.1.1.tar.gz
    rm -f szip-2.1.1.tar.gz 
fi
cd szip-2.1.1
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
if [[ ! -d hdf5-1.10.1.tar ]]; then
    if [[ ! -a hdf5-1.10.1.tar.gz ]]; then
        wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.1.tar.gz
    fi
    tar -xvzf hdf5-1.10.1.tar.gz
    rm -f hdf5-1.10.1.tar.gz
fi

export CC=icc
export F9X=ifort
export CXX=icpc

cd hdf5-1.10.1
mkdir /home/ubuntu/hdf5-1.10.1
./configure --prefix=/home/ubuntu/hdf5-1.10.1 --enable-fortran --enable-cxx
make
make check
make install
# https://github.com/HDFGroup/build_hdf5
# https://support.hdfgroup.org/ftp/HDF5/current/src/unpacked/release_docs/INSTALL_parallel
# https://support.hdfgroup.org/HDF5/release/obtainsrc.html