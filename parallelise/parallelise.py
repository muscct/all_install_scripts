import base64
import paramiko
import os

master_ip = "203.101.227.218"
with open("child_ips.txt", "r") as f:
    child_ips = f.readlines()
    child_ips = list(map(str.strip, child_ips))
private_key_path=privatekeyfile = os.path.expanduser('~/.ssh/cloud.key')
username="ubuntu"

key = paramiko.RSAKey.from_private_key_file(private_key_path, password='lipgloss')
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
# client.connect(master_ip, username='ubuntu', pkey=key)
# stdin, stdout, stderr = client.exec_command('ls')

def printInsideStars(string):
    length=len(string)
    print()
    print("*" * (len(string) + 4))
    print("* " + string + " *")
    print("*" * (len(string) + 4))
    print()

def runCommandOnNode(command, ip, printCommand=True, printOutput=True):
    global client
    client.connect(ip, username='ubuntu', pkey=key)
    stdin, stdout, stderr = client.exec_command(command)
    if printCommand:
        print("$" + command)
    if printOutput: 
        for line in stdout:
            print('... ' + line.strip('\n'))
        client.close()

def runCommandsOnNode(commands, ip, printCommand=True, printOutput=True):
    global client
    client.connect(ip, username='ubuntu', pkey=key)
    for command in commands:
        stdin, stdout, stderr = client.exec_command(command)
        if printCommand:
            print("$" + command)
        if printOutput: 
            for line in stdout:
                print('... ' + line.strip('\n'))
    client.close()

def runCommandOnMaster(command, printCommand=True, printOutput=True):
    global master_ip
    printInsideStars("Running on Master " + master_ip)
    runCommandOnNode(command, master_ip, printCommand, printOutput)

def runCommandOnChildren(command, printCommand=True, printOutput=True):
    global child_ips
    for (index, child_ip) in enumerate(child_ips):
        printInsideStars("Running on Child " + str(index+1) + "/" + str(len(child_ips)) + " " + child_ip )
        runCommandOnNode(command, child_ip, printCommand, printOutput)

def runCommandOnAll(command, printCommand=True, printOutput=True):
    runCommandOnMaster(command, printCommand, printOutput)
    runCommandOnChildren(command, printCommand, printOutput)

def runCommandsOnMaster(commands, printCommand=True, printOutput=True):
    global master_ip
    printInsideStars("Running on Master " + master_ip)
    runCommandsOnNode(commands, master_ip, printCommand, printOutput)

def runCommandsOnChildren(commands, printCommand=True, printOutput=True):
    global child_ips
    for (index, child_ip) in enumerate(child_ips):
        printInsideStars("Running on Child " + str(index+1) + "/" + str(len(child_ips)) + " " + child_ip )
        runCommandsOnNode(commands, child_ip, printCommand, printOutput)    

def runCommandsOnAll(commands, printCommand=True, printOutput=True):
    global master_ip
    global child_ips
    runCommandsOnMaster(commands, printCommand, printOutput)
    runCommandsOnChildren(commands, printCommand, printOutput)

# install openmpi
runCommandsOnAll([
    "sudo apt update", 
    "sudo apt --assume-yes install openmpi-bin libopenmpi-dev"
])

# set up shared NFS directory on master
runCommandsOnMaster([
    "sudo apt-get --assume-yes install nfs-kernel-server", 
    "mkdir -p $HOME/mpi-shared",
    "echo '$HOME/mpi-shared' *(rw,sync,no_root_squash,no_subtree_check)' | sudo tee --append /etc/apt/sources.list",
    "exportfs -a",
    "sudo service nfs-kernel-server restart"
])

# set up shared NFS on children
runCommandsOnChildren([
    "sudo apt-get install nfs-common",
    "mkdir -p $HOME/mpi-shared",
    "sudo mount -t nfs master:~/mpi-shared ~/mpi-shared",
    "echo '#MPI CLUSTER SETUP' | sudo tee --append /etc/fstab",
    "echo 'master:$HOME/mpi-shared $HOME/mpi-shared nfs' | sudo tee --append /etc/fstab"
])

# install openmc
runCommandsOnMaster([
    "sudo apt install -q -y libxml2-dev libxslt-dev libfreetype6-dev pkg-config libpng12-dev libxml2-dev libxslt-dev libfreetype6-dev pkg-config libpng12-dev git gfortran g++ cmake python-dev python-pip python3-pip openmpi-bin libopenmpi-dev python-tk",
    # "sudo python -m pip install pip==9.0.3 --upgrade --force-reinstall",
    # "sudo python3 -m pip3 install pip==9.0.3 --upgrade --force-reinstall",
    # "sudo pip install numpy six scipy pandas h5py matplotlib uncertainties lxml cython vtk silomesh pytest",
    "/usr/local/bin/pip install numpy",
    "/usr/local/bin/pip install six",
    "/usr/local/bin/pip install scipy",
    "/usr/local/bin/pip install pandas",
    "/usr/local/bin/pip install h5py",
    "/usr/local/bin/pip install matplotlib",
    "/usr/local/bin/pip install uncertainties",
    "/usr/local/bin/pip install lxml",
    "/usr/local/bin/pip install cython",
    "/usr/local/bin/pip install vtk",
    "/usr/local/bin/pip install silomesh",
    "/usr/local/bin/pip install pytest",
    "cd $HOME",
    "git clone https://github.com/mit-crpg/openmc.git",
    "wget https://s3.amazonaws.com/hdf-wordpress-1/wp-content/uploads/manual/HDF5/HDF5_1_10_4/hdf5-1.10.4.tar.gz",
    "tar -xvzf hdf5-1.10.4.tar.gz",
    "cd $HOME/hdf5-1.10.4",
    "sudo CC=mpicc FC=mpifort ./configure --enable-parallel --enable-shared --prefix=$HOME/openmc --with-zlib --enable-fortran",
    # "sudo CC=mpicc FC=mpifort ./configure --enable-parallel --prefix=$HOME/openmc --with-zlib --disable-shared --enable-fortran",
    "sudo make",
    "sudo make install",
    "cd $HOME/openmc",
    "git checkout master",
    "rm -rf build",
    "mkdir build",
    "cd build",
    "CC=mpicc FC=mpifort HDF5_ROOT=$HOME/openmc/bin cmake -DHDF5_PREFER_PARALLEL=on -Ddebug=on -Doptimize=on -DCMAKE_INSTALL_PREFIX=$HOME/openmc/install $HOME/openmc",
    "make",
    "cp $HOME/openmc/scripts/openmc-get-nndc-data .",
    "cp $HOME/openmc/scripts/openmc-ace-to-hdf5 .",
    "$HOME/openmc/openmc-get-nndc-data",
    "rm -f ./ENDF-B-VII.1-neutron-293.6K.tar.gz",
    "rm -f ./ENDF-B-VII.1-tsl.tar.gz",
    "rm -rf ./nndc",
    # "/nndc_hdf5/cross_sections.xml"
    # "mv ENDF-B-VII.1-neutron-293.6K.tar.gz $HOME/openmcData",
    "OPENMC_CROSS_SECTIONS=./nndc_hdf5/cross_sections.xml /mnt/openmc/build/bin/openmc /mnt/openmcData/INPUT/comp_files_final/competition_files/assembly/1",
    "OPENMC_CROSS_SECTIONS=$HOME/openmc/nndc_hdf5/cross_sections.xml $HOME/openmc/build/bin/openmc $HOME/openmcData/INPUT/comp_files_final/competition_files/assembly_large/1"
    "OPENMC_CROSS_SECTIONS=$HOME/openmc/nndc_hdf5/cross_sections.xml $HOME/openmc/build/bin/openmc $HOME/openmcData/INPUT/comp_files_final/competition_files/pincell/100000/120/1"

    
])