#############
# intel mpi #
#############
if [[ ! -d l_mpi_2018.3.222 ]]; then
    wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13063/l_mpi_2018.3.222.tgz
    tar -xvzf l_mpi_2018.3.222.tgz 
    rm -f l_mpi_2018.3.222.tgz
fi
cd l_mpi_2018.3.222
cp silent.cfg silent.cfg.bak
sed 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/' silent.cfg > silent.cfg
sudo bash install.sh --silent silent.cfg

# Intel MPI Fortran Compiler
if [[ ! -d parallel_studio_xe_2018_update3_composer_edition_for_fortran ]]; then
    wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13004/parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz
    tar -xvzf parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz 
    rm -f parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz 
fi

# Intel MPI C++ Compiler 
if [[ ! -d parallel_studio_xe_2018_update3_composer_edition_for_cpp ]]; then
    wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13003/parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
    tar -xvzf parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
    rm -f parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
fi

# find / -name "mpivars*"
source /opt/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/bin/mpivars.sh
# TODO: source mpivars.sh script from intel64/bin/
# TODO: source any required *{icc, ifort}vars.sh scripts.

cd ..

