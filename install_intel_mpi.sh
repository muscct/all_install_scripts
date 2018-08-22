set -e # abort script if any commands fail.
set -o pipefail # pipe exit code of chained commands to rightmost.
# set -v # print shell input lines as they are read.
# set -n read commands but do not execute them, used to check for syntax errors, ignored by interactive shells.

###############################
# Intel MPI Library for Linux #
###############################

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source $DIR/utils/get_archive.sh

function edit_silent_cfg {

    if [[ -a silent.cfg ]] ; then
        echo "Could not find the file $(pwd)/silent.cfg"
        exit 1
    fi

    if [[ ! -a silent.cfg.bak ]] ; then
        sudo cp silent.cfg silent.cfg.bak
        # sudo bash -c "sed 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/' silent.cfg | sed 's/#ACTIVATION_LICENSE_FILE=/ACTIVATION_LICENSE_FILE=\/home\/ubuntu\/licenses\/license.lic/' | sed 's/ACTIVATION_TYPE=exist_lic/ACTIVATION_TYPE=license_file/' > silent.cfg.new"
    fi

    sudo rm -f silent.cfg

    sudo cp $DIR/utils/intel_mpi_silent.cfg silent.cfg
}

echo "Installing Intel MPI..."


# Get source if not present
echo "Getting Intel MPI Library for Linux..."
get_archive l_mpi_2018.3.222 l_mpi_2018.3.222.tgz http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13063/l_mpi_2018.3.222.tgz
# if [[ ! -d l_mpi_2018.3.222 ]]; then
#     if [[ ! -a l_mpi_2018.3.222.tgz ]]; then
#         wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13063/l_mpi_2018.3.222.tgz
#     fi
#     tar -xvzf l_mpi_2018.3.222.tgz 
#     rm -f l_mpi_2018.3.222.tgz
# fi
# install
echo "Installing Intel MPI Library for Linux..."
cd l_mpi_2018.3.222
edit_silent_cfg
sudo bash install.sh --silent silent.cfg
# if [[ 0 -ne $? ]] ; then echo "Installing Intel MPI Library for Linux failed!" exit 1 fi
echo "Done installing Intel MPI Library for Linux!"
cd ..

##############################
# Intel MPI Fortran Compiler #
##############################

# Get source if not present
echo "Getting Intel MPI Fortran Compiler..."
get_archive parallel_studio_xe_2018_update3_composer_edition_for_fortran, parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13004/parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz
# if [[ ! -d  ]]; then
#     if [[ ! -a parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz ]]; then
#         wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13004/parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz 
#     fi
#     tar -xvzf parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz 
#     rm -f parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz 
# fi
# install
echo "Installing Intel MPI Fortran Compiler..."
cd parallel_studio_xe_2018_update3_composer_edition_for_fortran
edit_silent_cfg
sudo bash install.sh --silent silent.cfg
# if [[ 0 -ne $? ]] ; then echo "Installing Intel MPI Fortran Compiler failed!" exit 1 fi
echo "Done installing Intel MPI Fortran Compiler!"
cd ..

##########################
# Intel MPI C++ Compiler #
##########################

# Get source if not present
echo "Getting Intel MPI C++ Compiler..."
get_archive parallel_studio_xe_2018_update3_composer_edition_for_cpp parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13003/parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
# if [[ ! -d parallel_studio_xe_2018_update3_composer_edition_for_cpp ]]; then
#     if [[ ! -a parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz ]]; then
#         wget http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13003/parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
#     fi
#     tar -xvzf parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
#     rm -f parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
# fi
# install
echo "Installing Intel MPI C++ Compiler..."
cd parallel_studio_xe_2018_update3_composer_edition_for_cpp
edit_silent_cfg
sudo bash install.sh --silent silent.cfg
# if [[ 0 -ne $? ]] ; then echo "Installing Intel MPI C++ Compiler failed!" exit 1 fi
echo "Done installing Intel MPI C++ Compiler!"
cd ..

#####################################
# Make Intel MPI available to shell #
#####################################
echo "Sourcing Intel MPI vars..."
# find / -name "mpivars*"
source /opt/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/bin/mpivars.sh intel64
# TODO: source mpivars.sh script from intel64/bin/
# TODO: source any required *{icc, ifort}vars.sh scripts.
echo "Done sourcing Intel MPI vars!"
echo "Done installing Intel MPI!"