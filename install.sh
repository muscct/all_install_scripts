POSITIONAL=()
while [[ $# -gt 0 ]]
do
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
    SEISOL=true
    shift # past argument
    ;;
    -hpcg|--hpcg|-a|--all)
    HPCG=true
    shift # past argument
    ;;
    -hv|--horovod|-a|--all)
    HOROVOD=true
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

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
    sudo apt install -q -y libxml2-dev
    sudo apt install -q -y libxslt-dev
    sudo apt install -q -y libfreetype6-dev
    sudo apt install -q -y pkg-config
    sudo apt install -q -y libpng12-dev
    sudo python -m pip install pip==9.0.3 --upgrade --force-reinstall
    pip install numpy
    # alias python=python3
fi

sudo bash install_intel_mpi.sh

if [ "$LINPACK" = true ] ; then
    sudo bash install_linpack.sh
fi

if [ "$HPCG" = true ] ; then
    sudo bash install_hpcg.sh
fi

if [ "$OPENMC" = true | "$SEISOL" = true ] ; then
    sudo bash install_hdf5.sh
fi

if [ "$OPENMC" = true ] ; then
    sudo bash install_openmc.sh
fi

if [ "$SEISOL" = true ] ; then
    sudo bash install_seisol.sh
fi

if [ "$HOROVOD" = true ] ; then
    sudo bash install_horovod.sh
fi