function confirm() {
    # asks the user before executing a command
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

mkdir licenses
echo "Please download the Intel® Parallel Studio XE Cluster Edition for Linux license from:" &&
echo "  https://registrationcenter.intel.com/en/products/license/" &&
echo "And scp the license into:" &&
echo "  ubuntu@<ip>:$(pwd)/licenses/license.lic."
confirm "Press any key to continue..."


LINPACK=false
HPCG=false
OPENMC=false
SEISSOL=false
HOROVOD=false
HELP=false
CONCURRENT=false

POSITIONAL=()
while [[ $# -gt 0 ]] do
    key="$1"

    case $key in
        -o|--openmc|-a|--all)
        OPENMC=true
        shift # past argument
        # shift # past value
        ;;
        -l|--linpack|-a|--all)
        LINPACK=true
        shift # past argument
        ;;
        -s|--seisol|-a|--all)
        SEISSOL=true
        shift # past argument
        ;;
        -hc|--hpcg|-a|--all)
        HPCG=true
        shift # past argument
        ;;
        -hv|--horovod|-a|--all)
        HOROVOD=true
        shift # past argument
        ;;
        -h|--help)
        HELP=true
        shift # past argument
        ;;
        -c|--concurrent)
        CONCURRENT=true
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ HELP ]] 
    echo "Installs scc programs and their dependencies. Intel MPI is installed by default."
    echo "Options:"
    echo "  -h, --help: print this help message"
    echo "  -l, --linpack: install LINPACK"
    echo "  -hc, -hpcg: install High Performance Conjugate Gradients"
    echo "  -o, --openmc: install OpenMC and HDF5"
    echo "  -s, --seissol: install SeisSol and HDF5"
    echo "  -hv, --horovod: install Horovod"
    echo "  -a, --all: install all of the above"
    echo "  -c, --concurrent: perform installations at once"
elif [[ ! LINPACK -a ! HPCG -a ! OPENMC -a ! SEISOL -a ! HOROVOD ]] then;
    echo "No programs were selected for install, no changes have been made. Use -h for help."
    exit 0
fi

#####################
# pull dependencies #
#####################

sudo apt-get update
sudo apt-get install -q -y --reinstall build-essential
# general dependencies
sudo apt install -q -y git
sudo apt install -q -y gfortran
sudo apt install -q -y g++
sudo apt install -q -y cmake
sudo apt install -q -y python-dev
sudo apt install -q -y python-pip

if [ "$OPENMC" = true ] ; then
# openMC dependencies
    
    # alias python=python3
fi

sudo bash install_intel_mpi.sh

if [ "$LINPACK" = true ] ; then
    if [ "$CONCURRENT" = true ] ; then
        sudo bash install_linpack.sh &
    else
        sudo bash install_linpack.sh
    fi        
fi

if [ "$HPCG" = true ] ; then
    if [ "$CONCURRENT" = true ] ; then
        sudo bash install_hpcg.sh &
    else
        sudo bash install_hpcg.sh
    fi    
fi

if [ "$OPENMC" = true -o "$SEISSOL" = true ] ; then
    if [ "$CONCURRENT" = true ] ; then
        sudo bash install_hdf5.sh &
    else
        sudo bash install_hdf5.sh
    fi    
fi

if [ "$OPENMC" = true ] ; then
    if [ "$CONCURRENT" = true ] ; then
        sudo bash install_openmc.sh &
    else
        sudo bash install_openmc.sh
    fi    
fi

if [ "$SEISSOL" = true ] ; then
    if [ "$CONCURRENT" = true ] ; then
        sudo bash install_seisol.sh &
    else
        sudo bash install_seisol.sh
    fi    
fi

if [ "$HOROVOD" = true ] ; then
    if [ "$CONCURRENT" = true ] ; then
        sudo bash install_horovod.sh &
    else
        sudo bash install_horovod.sh
    fi    
fi