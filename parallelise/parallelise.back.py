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
])


runCommandsOnMaster([
    "sudo apt install -q -y libxml2-dev libxslt-dev libfreetype6-dev pkg-config libpng12-dev git",
    "sudo python -m pip install pip==9.0.3 --upgrade --force-reinstall",
    "sudo pip install numpy",
    "git clone https://github.com/mit-crpg/openmc.git",
    "mkdir -p /home/" + username + "/openmc",
    "wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.13/src/hdf5-1.8.13.tar.bz2",
    "tar -xaf hdf5-1.8.13.tar.bz2",
    "cd hdf5-1.8.13",
    "sudo CC=mpicc FC=mpifort ./configure --enable-parallel --prefix=/home/ubuntu/openmc --with-zlib --disable-shared --enable-fortran",
    "sudo make",
    "sudo make install",
    
])