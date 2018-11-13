set -e # abort script if any commands fail.
set -o pipefail # pipe exit code of chained commands to rightmost.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#####################
# Make Dependencies #
#####################

# sudo apt install -q -y libhdf5-dev

# szip dependency
if [[ ! -d szip-2.1.1 ]]; then
    if [[ ! -f szip-2.1.1.tar.gz ]]; then
        wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
    fi
    tar -xvzf szip-2.1.1.tar.gz
    rm -f szip-2.1.1.tar.gz 
fi
cd szip-2.1.1
mkdir -p szip
./configure --prefix=$(pwd)/szip
make
make check
make install
cd ..

# zlib only necessary if not compiling with cmake
# wget http://www.zlib.net/zlib-1.2.11.tar.gz
# tar -xvzf zlib-1.2.11.tar.gz

# hdf5
if [[ ! -d hdf5-1.10.1 ]]; then
    if [[ ! -f hdf5-1.10.1.tar.gz ]]; then
        wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.1.tar.gz
    fi
    tar -xvzf hdf5-1.10.1.tar.gz
    rm -f hdf5-1.10.1.tar.gz
fi

# source /opt/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/bin/mpivars.sh intel64
source /opt/intel/bin/compilervars.sh -arch intel64 -platform linux

export CC=mpicc
# export F9X=mpiifort
export F9X=mpif90
export CXX=mpiicpc

cd hdf5-1.10.1
mkdir -p hdf5-1.10.1
./configure --prefix=$(pwd)/hdf5-1.10.1 --enable-fortran --enable-cxx
make
make check
make install
cd ..
# https://github.com/HDFGroup/build_hdf5
# https://support.hdfgroup.org/ftp/HDF5/current/src/unpacked/release_docs/INSTALL_parallel
# https://support.hdfgroup.org/HDF5/release/obtainsrc.html