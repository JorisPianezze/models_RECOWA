#!/bin/bash
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#SBATCH --job-name=compile
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -o netcdf.eo%j
#SBATCH -e netcdf.eo%j
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ###################################
#          J. Pianezze
#          (08.07.2025)
#         ~~~~~~~~~~~~~~
#   Install AEC, HDF5 and NETCDF
#           librairies
#         ~~~~~~~~~~~~~~
# ###################################

if [ ! -e ../environment.sh ]; then
  echo '  envionment.sh file is missing'
  exit
else
  source ../environment.sh
fi

export dir_to_install=${PWD}/build_netcdf-${version_netcdf_fortran}

if [[ -d "$dir_to_install" ]]
then
  echo "$dir_to_install directory exists."
else
  mkdir $dir_to_install
fi

export compile_libaec=true
export compile_hdf5=true
export compile_netcdf_c=true
export compile_netcdf_fortran=true

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install libaec-${version_libaec}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_libaec} = true ]; then

  cd ${dir_to_install}/..
  if [[ ! -d libaec-${version_libaec} ]]
  then
    if [[ ! -e libaec-${version_libaec}.tar.gz ]]
    then
      echo 'You need to download libaec-'${version_libaec}'.tar.gz'
      echo 'stop'
      exit
    else
      tar xvfz libaec-${version_libaec}.tar.gz
    fi
  fi

  cd ${dir_to_install}/../libaec-${version_libaec}
  ./configure --disable-shared               \
              --prefix=${dir_to_install}     \
              --libdir=${dir_to_install}/lib \
              CC=${CC} CFLAGS="-fPIC"
  make -j 1
  make install
  make clean

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install hdf5-${version_hdf5}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_hdf5} = true ]; then

  cd ${dir_to_install}/..
  if [[ ! -d hdf5-${version_hdf5} ]]
  then
    if [[ ! -e hdf5-${version_hdf5}.tar.gz ]]
    then
      echo 'You need to download hdf5-'${version_hdf5}'.tar.gz'
      echo 'stop'
      exit
    else
      tar xvfz hdf5-${version_hdf5}.tar.gz
    fi
  fi

  cd ${dir_to_install}/../hdf5-${version_hdf5}
  ./configure --enable-fortran \
              --disable-shared \
              --enable-parallel \
              --prefix=${dir_to_install} \
              --libdir=${dir_to_install}/lib \
              --with-szlib=${dir_to_install}/include,${dir_to_install}/lib \
              CC=${CC} CFLAGS="-fPIC" FC=${FC} FCFLAGS="-fPIC" \
              LDFLAGS="-L${dir_to_install}/lib" LIBS="-lsz -laec -lz"
  make -j 1
  make install
  make clean

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-c-${version_netcdf_c}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_netcdf_c} = true ]; then

  cd ${dir_to_install}/..
  if [[ ! -d netcdf-c-${version_netcdf_c} ]]
  then
    if [[ ! -e netcdf-c-${version_netcdf_c}.tar.gz ]]
    then
      echo 'You need to download netcdf-c-'${version_netcdf_c}'.tar.gz'
      echo 'stop'
      exit
    else
      tar xvfz netcdf-c-${version_netcdf_c}.tar.gz
    fi
  fi

  cd ${dir_to_install}/../netcdf-c-${version_netcdf_c}
  ./configure --disable-shared \
              --disable-libxml2 \
              --disable-dap \
              --disable-byterange \
              --prefix=${dir_to_install} \
              --libdir=${dir_to_install}/lib \
              CC=${CC} CFLAGS="-fPIC" \
              CPPFLAGS="-I${dir_to_install}/include" \
              LDFLAGS="-L${dir_to_install}/lib" \
              LIBS="-lhdf5_hl -lhdf5 -lsz -laec -lz -ldl"
  make -j 1
  make install
  make clean

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-fortran-${version_netcdf_fortran}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_netcdf_fortran} = true ]; then

  cd ${dir_to_install}/..
  if [[ ! -d netcdf-fortran-${version_netcdf_fortran} ]]
  then
    if [[ ! -e netcdf-fortran-${version_netcdf_fortran}.tar.gz ]]
    then
      echo 'You need to download netcdf-fortran-'${version_netcdf_fortran}'.tar.gz'
      echo 'stop'
      exit
    else
      tar xvfz netcdf-fortran-${version_netcdf_fortran}.tar.gz
    fi
  fi

  cd ${dir_to_install}/../netcdf-fortran-${version_netcdf_fortran}
  ./configure --disable-shared \
              --prefix=${dir_to_install} \
              --libdir=${dir_to_install}/lib \
              CC=${CC} CFLAGS="-fPIC" FC=${FC} FCFLAGS="-fPIC" FFLAGS="-fPIC"  \
              CPPFLAGS="-I${dir_to_install}/include" \
              LDFLAGS="-L${dir_to_install}/lib" \
              LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lsz -laec -lz -ldl"
  make -j 1
  make install
  make clean

fi
