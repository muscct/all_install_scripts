module load intel
export PATH=$PATH:$HOME/libxsmm/bin
cd $HOME/SeisSol/auto_tuning/proxy
scons memLayout=$HOME/SeisSol/auto_tuning/config/elastic_dknl_O2.xml numberOfMechanisms=1 order=6
