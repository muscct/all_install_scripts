#############
# intel mpi #
#############

# Get source if not present
if [[ ! -d l_mpi_2018.3.222 ]]; then
    if [[ ! -a l_mpi_2018.3.222.tgz ]]; then
        wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13063/l_mpi_2018.3.222.tgz
    fi
    tar -xvzf l_mpi_2018.3.222.tgz 
    rm -f l_mpi_2018.3.222.tgz
fi
# install
cd l_mpi_2018.3.222
edit_silent_cfg
sudo bash install.sh --silent silent.cfg
cd ..

##############################
# Intel MPI Fortran Compiler #
##############################

# Get source if not present
if [[ ! -d parallel_studio_xe_2018_update3_composer_edition_for_fortran ]]; then
    if [[ ! -a parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz ]]; then
        wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13004/parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz
    fi
    tar -xvzf parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz 
    rm -f parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz 
fi
# install
cd parallel_studio_xe_2018_update3_composer_edition_for_fortran
edit_silent_cfg()
sudo bash install.sh --silent silent.cfg
cd ..

##########################
# Intel MPI C++ Compiler #
##########################

# Get source if not present
if [[ ! -d parallel_studio_xe_2018_update3_composer_edition_for_cpp ]]; then
    if [[ ! -a parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz ]]; then
        wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13003/parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
    fi
    tar -xvzf parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
    rm -f parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
fi
# install
cd parallel_studio_xe_2018_update3_composer_edition_for_cpp
sudo bash -c "sed 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/' silent.cfg > silent.cfg"
sudo bash install.sh --silent silent.cfg
cd ..

#####################################
# Make Intel MPI available to shell #
#####################################

# find / -name "mpivars*"
source /opt/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/bin/mpivars.sh intel64
# TODO: source mpivars.sh script from intel64/bin/
# TODO: source any required *{icc, ifort}vars.sh scripts.

function edit_silent_cfg {
    cp silent.cfg silent.cfg.bak
    sudo bash -c "sed 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/' silent.cfg > silent.cfg.new"
    sudo bash -c "sed 's/#ACTIVATION_LICENSE_FILE=/ACTIVATION_LICENSE_FILE=\/home\/ubuntu\/licenses\/license.lic/' silent.cfg > silent.cfg.new"
    sudo bash -c "sed 's/ACTIVATION_TYPE=exist_lic/ACTIVATION_TYPE=license_file/' silent.cfg > silent.cfg.new"
    sudo mv silent.cfg.new silent.cfg
}