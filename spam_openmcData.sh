dir=$HOME/openmcData/INPUT/comp_files_final/competition_files/pincell/

# for i in /shared/home/ccuser/openmcData/INPUT/comp_files_final/competition_files/pincell/*; do 
for i in $dir/*; do 
    echo "$i";
    for j in $i/*; 
        do for k in $j/*; do 
            logfile=$HOME/pincell$(basename $i)$(basename $j)$(basename $k).txt 
            sudo touch $logfile 
            sudo OPENMC_CROSS_SECTIONS=./nndc_hdf5/cross_sections.xml ./build/bin/openmc $k | sudo tee --append $logfile; 
        done; 
    done; 
done