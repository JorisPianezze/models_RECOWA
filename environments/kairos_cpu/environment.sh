#!/bin/bash

# #######################################################################
#
#   Environment for kairos on CPU nodes
#
# #######################################################################

module purge

module load oneapi/2025.3
module load 2025.3/compiler/2025.3.2
module load 2025.3/mpi/2021.17

export CC=mpiicx
export FC=mpiifx

# Set LD_PRELOAD for all oneAPI version to workaround conflicts between
# libm and libimf that crashes ar and nm
export LD_PRELOAD=/lib64/libm.so.6

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    Components available and already tested on this machine
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# |------------|--------------------------------|-----------------------------------|---------|
# | Component  | Description                    | Dependance                        | Tested  |
# |------------|--------------------------------|-----------------------------------|---------|
# | netcdf     | NetCDF library                 | -                                 |   [X]   |
# | oasis      | OASIS3-MCT coupler             | netcdf                            |   [ ]   |
# | xios       | XIOS server (no OASIS support) | netcdf                            |   [X]   |
# | xios_oasis | XIOS server (OASIS support)    | netcdf, oasis                     |   [ ]   |
# | croco      | CROCO oceanic model            | netcdf, (oasis, xios, xios_oasis) |   [X]   |
# | mesonh     | Meeo-NH atmospheric model      | netcdf, (oasis)                   |   [ ]   |
# | ww3        | WW3 oceanic wave model         | netcdf, (oasis)                   |   [ ]   |
# | wrf        | WRF atmospheric model          | netcdf, (oasis)                   |   [ ]   |
# |------------|--------------------------------|-----------------------------------|---------|

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Components to install
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export components='netcdf oasis xios xios_oasis croco mesonh'

module list
