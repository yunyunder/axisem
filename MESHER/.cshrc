#!/bin/tcsh
set GMT5HOME = /home/userlibs/GMT/GMT5.4.1


set host = `echo $HOST | awk -F. ' { print $1 } '`
if ( $host == "gpnfs" ) then
set path=( /home/userlibs/java/jre1.6.0_02/bin  /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/src /usr/X11R6/bin . )
else if ( $host == "c2q17" ) then
set path=( /home/userlibs/java/jre1.6.0_02/bin /opt/intel/Compiler/11.0/074/bin/intel64 /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/src /usr/X11R6/bin . )
else
set path=( /home/userlibs/anaconda3/bin /home/userlibs/GCC/gcc-9.2.0/bin /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/src /usr/X11R6/bin . )
endif
set path = ( $path \
             #/home/userlibs/gcc/gcc-build-8.1.0/bin \
             /opt/openmpi-4.0.2-gcc/bin \
             /opt/intel/bin \
             /opt/passcal/bin \
             /opt/intel/cce/10.0.023/bin \
             /home/userlibs/intel9.1/cce/bin \
             /home/userlibs/intel9.1/cc/bin \
             /home/userlibs/intel9.1/fce/bin \
             /home/userlibs/intel9.1/fc/bin \
             /home/userlibs/PathScale/bin \
             $GMT5HOME/bin \
#             /home/userlibs/GMT5.1.1/bin \
             /home/userlibs/GMT/GMT4.5.6/bin \
#             /home/userlibs/sac2000/bin \
             /home/userlibs/sac101.4/bin \
             /home/userlibs/rdseedv5.2 \
             /home/userlibs/sarsuite6.0 \
             /home/userlibs/TauP-2.1.2/bin \
             /home/userlibs/netcdf-3.5/bin \
	     /home/userlibs/sod-3.2.8/bin \
	     /home/sean \
	     /home/sean/bin \
             /home/shung/SEISWARES/bin \
	     /home/userlibs/sac2000/utils/SAC2LINUX \
#	     /home/userlibs/iGMT/igmt_1.2 \
             /home/userlibs/matlab7.3/bin \
	     /home/userlibs/matlab7.2/bin \
	     /home/userlibs/pgiacc/linux86-64/10.9/bin \
             /home/shung/SEISWARES/bin \
             /home/shung/SEISWARES/ttimes/bin \
	     /home/userlibs/dx/bin \
             /usr/local/Trolltech/Qt-4.3.3/bin \
             /home/userlibs/mpich/bin \
             /home/sean/3DVisualizer-1.0/bin \
             /home/sean/Work2/Mars/cluster/src/ffm3d\
             /home/sean/src/shell \
             /opt/open64/bin/ \
             /home/shung/bin \
             /home/sean/bin/src_mise \
             /usr/local/git/bin \
             /home/sean/Work17/julia/bin )

if ( $host == "gluon" ) then
set path=( $path /home/userlibs/lam-7.1.4/bin )
endif

#             /home/userlibs/intel_fce9.0/bin /home/userlibs/intel_fc9.0/bin 
#             /usr/java/j2re1.4.1_05/bin \
#             /usr/lib/jdk.1.1.8/bin \
#             /home/ysinging/Taup/bin \
#	     /usrlibs/mpich-1.2.2/bin 

### manpage######            
if ( $host == "c2q17" ) then
setenv MANPATH /usr/local/man:/usr/local/share/man:/opt/intel/Compiler/11.0/074/man:/home/userlibs/intel_fce9.0/man:/home/userlibs/intel_fc9.0/man:/home/userlibs/intel_cc/intel_cc_80/man:/home/sean/java/jre1.5.0_06/man:/home/sean/man
else
setenv MANPATH /usr/local/man:/usr/local/share/man:/opt/intel/man/common:/home/userlibs/intel_fc9.0/man:/home/userlibs/intel_cc/intel_cc_80/man:/home/sean/java/jre1.5.0_06/man:/home/sean/man#/home/userlibs/absoft11.0/absoft11.0/man

endif

setenv MANPATH /usr/man:/usr/share/man:$GMT5HOME/share/man:/home/userlibs/rdseedv5.2/Man:/home/userlibs/pgiacc/linux86-64/10.9/man:/usr/local/man:/home/userlibs/PathScale/man:/home/userlibs/mpich/man/man1:$MANPATH

#setenv LD_LIBRARY_PATH /usr/local/Trolltech/Qt-4.3.3/lib:/usr/local/rrdtool-1.2.23/lib:/usr/local/lib64:/usr/lib64:/usr/local/lib:/usr/lib:/opt/intel/fce/10.0.023/lib:/home/userlibs/intel_fce9.0/lib:/home/userlibs/intel_fc9.0/lib:/home/userlibs/java/jre1.5.0_09/lib:/usr/local/MPICH2/lib:/usr/X11R6/lib:/home/userlibs/GMT4.5.6/netcdf-3.6.2/lib:/opt/intel/mkl/9.1.023/lib/64:/opt/intel/cce/10.0.023/lib:/home/userlibs/lam-7.1.4/lib:/home/sean/gluontmphome/BLAS:/home/userlibs/PathScale/lib/2.5:/home/sean/Work2/SESARRAY/sesarray-src-2.0.0-snapshot-20080118/lib
if ( $host == "c2q17" ) then
setenv LD_LIBRARY_PATH /usr/local/lib64:/usr/lib64:/usr/local/lib:/usr/lib:/opt/intel/Compiler/11.0/074/lib/intel64:/home/userlibs/java/jre1.5.0_09/lib:/usr/X11R6/lib:$GMT5HOME/lib64:/opt/intel/Compiler/11.0/074/mkl/lib/em64t/lib:/opt/intel/cce/10.0.023/lib:/home/userlibs/PathScale/lib/2.5:/home/sean/Work2/Inversion/MainProgram
else
setenv LD_LIBRARY_PATH /home/userlibs/GCC/gcc-9.2.0/lib:/home/userlibs/GCC/gcc-9.2.0/lib64:/usr/lib64:/opt/intel/composerxe-2011.1.107/compiler/lib/intel64:/usr/local/lib64:/usr/lib32:/usr/local/lib:/usr/lib:/opt/intel/fce/10.0.023/lib:/home/userlibs/java/jre1.5.0_09/lib:/usr/X11R6/lib:/home/userlibs/GMT/GMT4.5.6/netcdf-3.6.3/lib:/opt/intel/mkl/9.1.023/lib/64:/opt/intel/cce/10.0.023/lib:/home/userlibs/PathScale/lib/2.5:/home/sean/Work2/Inversion/MainProgram:/home/sean/Documents/pgploit:/home/userlibs/nrecipes:/home/userlibs/openmpi/lib:/home/userlibs/pgiacc/linux86-64/10.9/lib:/home/userlibs/pgiacc/linux86-64/2010/cuda/3.1/lib:/home/userlibs/cuda/lib64:/home/userlibs/cuda/lib:/usr/local/cuda/lib64:/opt/open64/lib/gcc-lib/x86_64-open64-linux/5.0:/opt/open64/lib/gcc-lib/x86_64-open64-linux/5.0/64:/opt/intel/composer_xe_2015.3.187/compiler/lib/intel64:/opt/intel/compilers_and_libraries_2017.0.098/linux/compiler/lib/intel64:/opt/openmpi-4.0.2-gcc/lib
endif

#setenv LD_LIBRARY_PATH /opt/intel/fce/10.0.023/lib:/opt/intel/cce/10.0.023/lib/
#setenv LD_LIBRARY_PATH /opt/intel/fce/10.0.023/lib:/opt/intel/fc/10.0.023/lib:/opt/intel/cce/10.0.023/lib:/opt/intel/cc/10.0.023/lib:/home/userlibs/java/jre1.6.0_02/lib:/home/userlibs/PathScale/lib/3.0:/home/userlibs/GMT4.5.6/netcdf-3.6.2/lib
#setenv LD_LIBRARY_PATH /opt/intel/fce/10.0.023/lib:/opt/intel/fc/10.0.023/lib:/opt/intel/cce/10.0.023/lib:/opt/intel/cc/10.0.023/lib:/home/userlibs/java/jre1.6.0_02/lib:/home/userlibs/PathScale/lib/3.0:/tmphome/ClusterTools/lamtest/lib:/home/userlibs/GMT4.5.6/netcdf-3.6.2/lib
#setenv LD_LIBRARY_PATH /opt/intel/fce/10.0.023/lib:/opt/intel/fc/10.0.023/lib:/opt/intel/cce/10.0.023/lib:/opt/intel/cc/10.0.023/lib

### Others
#setenv SACAUX /home/userlibs/sac2000/aux
#setenv SACLIB /home/userlibs/sac2000/lib
setenv SACAUX /home/userlibs/sac101.4/aux
setenv SACLIB /home/userlibs/sac101.4/lib
setenv SACGRAPHICS xwindow

setenv GMTHOME /home/userlibs/GMT/GMT4.5.6
#setenv NETCDFHOME /home/userlibs/GMT/GMT4.5.6/netcdf-3.6.3
#setenv SOD_HOME /home/userlibs/sod-2.2.1
setenv JAVALIB /home/userlibs/java/jre1.5.0_06/lib
setenv MATLAB_JAVA /home/userlibs/java/jre1.6.0_02
setenv TAUP_HOME /home/userlibs/TauP-2.1.2
#setenv igmt_root /home/userlibs/iGMT/igmt_1.2
setenv GMT_GRIDDIR /home/userlibs/geoware/DATA/grids
setenv GMT_IMGDIR  /home/userlibs/geoware/DATA/img
setenv GMT_DATADIR /home/userlibs/geoware/DATA/misc
setenv PGI /home/userlibs/pgiacc
setenv TTHOME /home/shung/SEISWARES/ttimes
#setenv PGI /home/userlibs/pgi-64
setenv LM_LICENSE_FILE $PGI/license.dat
setenv LAMRSH ssh
set host2 = `echo $host | awk '{print substr($1,1,3)}'`
set host3 = `echo $host | awk '{print substr($1,1,2)}'`
if ( $host == 'c2q21' ) then
setenv OMP_NUM_THREADS 8
#else if ( $host == 'c2q22' ) then
#setenv OMP_NUM_THREADS 6
#else if( $host2 == "c2q" ) then
#setenv OMP_NUM_THREADS 4
#else if ( $host3 == "xo" ) then
#setenv OMP_NUM_THREADS 4
#else if ( $host == 'gluon' ) then
#setenv OMP_NUM_THREADS 12
else if ( $host == 'xo1' ) then
setenv OMP_NUM_THREADS 28
else if ( $host == 'higgs' ) then
setenv OMP_NUM_THREADS 30
else if ( $host == 'bayron' ) then
setenv OMP_NUM_THREADS 60
endif
setenv _POSIX2_VERSION 199209
setenv INTEL_LICENSE_FILE /home/sean/intel/licenses 
unset autologout
setenv KMP_SHARABLE_STACKSIZE 512M
setenv KMP_STACKSIZE 512M

# for complie
#setenv FC f77
#setenv FFLAGS -O3
#setenv LIBS -lessl

#setenv CLASSPATH /home/ysinging/Taup/taup.jar:/usr/java/j2re1.4.1_05/javaws-1_2_0_05-linux-i586-i.zip


### Alias ###
alias rm 'rm -i'
#alias sac 'sac2000'
alias ls  'ls --color '
alias mv 'mv -i'
alias cp  'cp -p -i'
alias vi 'vim'
alias a2ps 'a2ps -PCM2320 -C -Ma4 --sides=tumble --setpagedevice=ManualFeed:false'
alias ssh 'ssh -XY'
alias mpdst 'mpd --ncpus=4 &'
alias mpdot 'mpdallexit'
alias h 'history | tail -20'
alias grep 'grep --color=auto'
#alias mpirun '/usrlibs/mpich-1.2.5.2/bin/mpirun'
#alias gv  'kghostview'
#alias 'useradd' 'useradd -d /home/yang -g users -m -s /bin/tcsh -u 510 yang'
#alias gfortran '/usr/local/bin/gfortran'
#alias gcc '/home/userlibs/gcc/gcc-build-8.1.0/bin/gcc'
#alias g++ '/home/userlibs/gcc/gcc-build-8.1.0/bin/g++'
#alias c++ '/home/userlibs/gcc/gcc-build-8.1.0/bin/c++'
alias gv 'gv -noantialias'

set myws = `echo $HOST | awk -F. ' { print $1 } '`
#alias setprompt 'set prompt="{`whoami`@$myws}[`pwd`]: "'
alias setprompt 'set prompt="{%{^[[1;32m%}`whoami`%{^[[0m%}@%{^[[1;34m%}$myws%{^[[0m%}}[%{^[[36m%}`pwd`%{^[[0m%}]: "'

alias cd        'set OLDDIR=$cwd; chdir \!*; setprompt'
alias ba        'set BACKDIR=$OLDDIR; set OLDDIR=$cwd; cd $BACKDIR; unset BACKDIR; setprompt'


##################################
alias pion '140.112.57.184'
alias kaon '140.112.57.186'
alias cluster '140.112.57.181'
#################################
#alias ssh 'ssh -Y'
alias gs 'gs -sDEVICE=x11 -sPAPERSIZE=a4'
alias fc32 '/home/userlibs/intel9.1/fc/bin/ifort'
alias fc64t '/home/userlibs/intel9.1/fce/bin/ifort'
#alias pgf95 'pgf95 $1.f -Mextend -tp k8-64 -mcmodel=medium -O -C -o $1'
alias compifort 'ifort -132 -O4 -C -zero -save -convert big'
alias compm 'ifort -132 -O4 -C -zero -save -convert big -o \!* \!*.f'
alias compm90 'ifort -132 -O4 -C -zero -save -convert big -o \!* \!*.f90'
alias comppgf 'pgf77 -Mextend -tp k8-64 -mcmodel=medium -O4 -Msave -Mbyteswapio -o \!* \!*.f'
alias comppath 'pathf95 -extend-source -convert big_endian -o  \!* \!*.f'

#===
setenv ABSOFT /opt/absoft11.0
set path = ( $ABSOFT/bin $path )
