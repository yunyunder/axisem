#!/bin/bash
<<<<<<< HEAD

#cp make_axisem.macros.TEMPLATE make_axisem.macros
cp make_axisem.macros.TEMPLATE.yin make_axisem.macros
cp SOLVER/Makefile.TEMPLATE SOLVER/Makefile
cp SOLVER/UTILS/Makefile.TEMPLATE SOLVER/UTILS/Makefile
cp MESHER/Makefile.TEMPLATE MESHER/Makefile
cp MESHER/inparam_mesh.TEMPLATE MESHER/inparam_mesh
=======
if [ $# -eq 1 ] && [ $1 == 'release' ]; then
  echo "Copying files for fast code"
  cp make_axisem.macros_release.TEMPLATE make_axisem.macros
elif [ $# -eq 1 ] && [ $1 == 'coverage' ]; then
  echo "Copying files for coverage analysis"
  cp make_axisem.macros_coverage.TEMPLATE make_axisem.macros
else
  echo "Copying files for debugging"
  cp make_axisem.macros.TEMPLATE make_axisem.macros
fi
cp MESHER/Makefile.TEMPLATE MESHER/Makefile
cp MESHER/Makefile.TEMPLATE MESHER/Makefile
cp MESHER/inparam_mesh.TEMPLATE MESHER/inparam_mesh

cp SOLVER/Makefile.TEMPLATE SOLVER/Makefile
cp SOLVER/UTILS/Makefile.TEMPLATE SOLVER/UTILS/Makefile
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
cp SOLVER/inparam_basic.TEMPLATE SOLVER/inparam_basic
cp SOLVER/inparam_advanced.TEMPLATE SOLVER/inparam_advanced
cp SOLVER/STATIONS.TEMPLATE SOLVER/STATIONS
cp SOLVER/inparam_source.TEMPLATE SOLVER/inparam_source
cp SOLVER/inparam_hetero.TEMPLATE SOLVER/inparam_hetero
cp SOLVER/CMTSOLUTION.TEMPLATE SOLVER/CMTSOLUTION
<<<<<<< HEAD
=======

cp Makefile.TEMPLATE Makefile

cp SOLVER/inparam_basic.TEMPLATE inparam_basic
cp SOLVER/inparam_advanced.TEMPLATE inparam_advanced
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
