#!/bin/bash

module purge

export machine='turpan'

module load nvidia
module load nvhpc/24.11-openmpi.4.1.5
module load cmake/3.25.1
module load conda/25.1.1
conda activate env_models

export CUDALEVEL=cuda12.6
export OPT_CPTCAP=cc80

export MPI_ROOT=/usr/local/nvidia/nvhpc/Linux_aarch64/24.11/comm_libs/11.8/openmpi4/openmpi-4.1.5

export CC=mpicc
export FC=mpif90

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
export XIOSDIR=path_to_models_directory/xios-3.0-trunk
export XIOSDIR_OASIS=path_to_models_directory/xios-3.0-trunk_oasis3-mct_${version_oasis}

module list
