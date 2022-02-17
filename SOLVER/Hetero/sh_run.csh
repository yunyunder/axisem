#!/bin/csh
set run_dir = /home/yin/axisem/SOLVER

foreach dir(`cat dir_list`)
    echo $dir
    \cp $dir/*sph $dir/CMTSOLUTION $run_dir
    \cp $dir/STATIONS $run_dir
    #cp STATIONS $run_dir
    cd $run_dir
./submit.csh PREM_1s_${dir} -q torque 
    cd Hetero

end


##set run_dir = /home/u5824055/axisem/SOLVER
#set run_dir = /work1/u5824055/axisem/SOLVER
##set event = 20181120
#
#set type = s40_local
#
#foreach event(`cat cmt_list`)
##foreach event(`cat list_local_ryukyu`)
##set event = 20181120
#    set dir = ${type}_${event}
#    echo $dir
#    cp $dir/*sph $dir/CMTSOLUTION $run_dir
#    cp $dir/STATIONS $run_dir
#    cat $run_dir/CMTSOLUTION
#
#    cd $run_dir
#./submit.csh PREM_1s_${event}_${type} -q torque
#    cd Hetero
#
#end
