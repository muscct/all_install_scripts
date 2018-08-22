# If you have the source files, this script will scp them to a node for you

copy_file() {
    if [[ -a $2 ]] ; then
        scp $2 $1:~/$2
        echo "Copied $2"
    else
        echo "Could not find $2"
    fi
}

if [ "$1" = "" ]; then
    echo "Yo, you gotta put <username>@<IP address> as the first positional argument when you run this script."
    exit 1
fi

copy_file $1 l_mpi_2018.3.222.tgz
copy_file $1 parallel_studio_xe_2018_update3_composer_edition_for_fortran.tgz
copy_file $1 parallel_studio_xe_2018_update3_composer_edition_for_cpp.tgz
copy_file $1 szip-2.1.1.tar.gz
copy_file $1 hdf5-1.10.1.tar
if [[ -d licenses -a -a license.lic ]] ; then
    scp -r licenses $1:~/
    echo "Copied licenses"
else
    echo "Could not find licenses, should be in ./licenses/license.lic"
fi


