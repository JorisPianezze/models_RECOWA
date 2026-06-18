#!/bin/bash

module purge

export machine='belenos'

module load gcc/14.1.0
module load intel/2019.5.281
module load openmpi/intel/4.0.2.2
module load cmake/3.15.4

export CC=gcc
export CXX=g++
export FC=ifort
export OMPI_FC=ifort
export SPLL=spll_new

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
