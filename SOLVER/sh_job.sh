 #!/bin/sh
 ### Job name
 #PBS -N TestRun
 ### Output files
 #PBS -e testrun.err
 #PBS -o testrun.log
 ### Queue name (n, default)
 #PBS -q default
 ### Number of nodes
 #PBS -l nodes=2:ppn=4
 PBS_O_WORKDIR=/home/yin/axisem/SOLVER

 echo "========================================================================"
 echo "Starting on `hostname` at `date`"
 echo "========================================================================"
 if [ -n "$PBS_NODEFILE" ]; then
    if [ -f $PBS_NODEFILE ]; then
       # print the nodenames.
       echo "Nodes used for this job:"
       cat ${PBS_NODEFILE}
       NPROCS=`wc -l < $PBS_NODEFILE`
    fi
 fi

 # Display this job's working directory
 echo Working directory is $PBS_O_WORKDIR
 cd $PBS_O_WORKDIR

 # Use mpiexec to run MPI program.
 #/opt/openmpi/../bin/mpiexec your_mpi_program
 ./submit.csh PREM_test -q torque
 
 echo "========================================================================"
 echo "Job Ended at `date`"
/ echo "========================================================================"
