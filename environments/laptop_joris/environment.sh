#!/bin/bash

# #######################################################################
#
#   Environment for laptop_joris (Ubuntu 20.04)
#
# #######################################################################

source /home/piaj/04_tools_libs/spack/share/spack/setup-env.sh
spack load gcc@13.4.0

export CC=mpicc
export FC=mpif90

export components='libraries oasis xios xios_oasis croco mesonh ww3 wrf'
