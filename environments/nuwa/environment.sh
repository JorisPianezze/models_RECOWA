#!/bin/bash

module purge

export machine='nuwa'

. /home/tools/intel/psxe2018/bin/ifortvars.sh intel64
export MPI_ROOT=/usr/local/openmpi/4.0.4/ifort18.0.2.199
export PATH=$MPI_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$MPI_ROOT/lib64:$LD_LIBRARY_PATH
export MANPATH=$MPI_ROOT/share/man:$MANPATH

export CC=cc
export FC=ifort

export version_libaec='1.1.3'
export version_hdf5='1.14.6'
export version_netcdf_c='4.9.3'
export version_netcdf_fortran='4.6.1'
export version_oasis='5.2'
export version_mesonh='5-7-2'
export version_croco='2.1.0'
export version_ww3='7.14'

export NETCDF_CONFIG=path_to_models_directory/libraries/build_netcdf-${version_netcdf_fortran}/bin/nf-config
export OASISDIR=path_to_models_directory/oasis3-mct_${version_oasis}/build_oa3-mct

module list
