#!/bin/bash

# #######################################################################
#
#   Environment for laptop_mathieu (Ubuntu 24.04)
#
# #######################################################################

export CC=mpicc
export FC=mpif90

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

export components='netcdf xios croco'
