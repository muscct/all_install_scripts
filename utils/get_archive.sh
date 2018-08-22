function get_archive {

    if [ "$1" = "" ]; then
        echo "Yo, you gotta put the name of the extracted file as the first positional argument when you run this script."
        exit 1
    fi

    if [ "$2" = "" ]; then
        echo "Yo, you gotta put the archive file as the second positional argument when you run this script."
        exit 1
    fi

    if [ "$3" = "" ]; then
        echo "Yo, you gotta put the url to retrieve the file from as the third positional argument when you run this script."
        exit 1
    fi

    if [[ ! -d $1 ]]; then
        if [[ ! -a $2 ]]; then
            wget $3
        fi
        if  file $2 | grep -q 'tar archive' ; then
            tar -xvf $2
        elif file $2 | grep -q 'gzip compressed data' ; then
            tar -xvzf $2 
        else
            echo "Unknown file format"
            exit 1
        fi
        rm -f $2
    fi
}