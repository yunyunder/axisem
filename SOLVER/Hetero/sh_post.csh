#!/bin/csh 

set loop_path = /home/yin/axisem/SOLVER/HETERO
set axi_path = /home/yin/axisem/SOLVER


foreach dir (`cat syn_list`)
    echo $dir

    cd $axi_path/$dir

    set script = sh_post_pro.pbs
    echo '#PBS -q ctest' > $script
    echo '#PBS -l walltime=00:30:00' >> $script
    echo '#PBS -o test.log'  >> $script
    echo '#PBS -l nodes=1:ppn=1' >> $script
    echo '#PBS -N axi_post' >> $script
    echo '#PBS -P MST109435' >> $script
    echo "cd /work1/u5824055/axisem/SOLVER/${dir}" >> $script
    echo 'module load mpi/openmpi-3.0.0/gcc640 gcc/6.4.0' >> $script
    echo ''>> $script
    echo 'mpirun -np 1 ./post_processing.csh' >> $script
    qsub $script

    cd $loop_path 

end #event 

