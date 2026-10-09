#!/bin/bash

# #######################################################################
#
#          J. Pianezze
#          (08.07.2025)
#         ~~~~~~~~~~~~~~
#   Install AEC, HDF5 and NETCDF
#           librairies
#         ~~~~~~~~~~~~~~
#
# #######################################################################

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
export compile_zstd=true
export compile_hdf5=true
export compile_netcdf_c=true
export compile_netcdf_fortran=true

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install libaec-${version_libaec}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_libaec} = true ]; then

  if [ ! -f ${dir_to_install}/lib/libaec.a ]; then

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
    LD_PRELOAD=${LD_PRELOAD} ./configure \
	        --prefix=${dir_to_install} \
                --libdir=${dir_to_install}/lib \
                CC=${CC} CFLAGS="-fPIC"
    LD_PRELOAD=${LD_PRELOAD} make -j 1
    LD_PRELOAD=${LD_PRELOAD} make install
    LD_PRELOAD=${LD_PRELOAD} make clean

  else
    echo "  libaec-${version_libaec} already compiled -> nothing has been done."
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install zstd-${version_zstd} 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_zstd} = true ]; then

  if [ ! -f ${dir_to_install}/lib/libzstd.a ]; then

    cd ${dir_to_install}/..
    if [[ ! -d zstd-${version_zstd} ]]
    then
      if [[ ! -e zstd-${version_zstd}.tar.gz ]]
      then
        echo 'You need to download zstd-'${version_zstd}'.tar.gz'
        echo 'stop'
        exit
      else
        tar xvfz zstd-${version_zstd}.tar.gz
      fi
    fi

    cd ${dir_to_install}/../zstd-${version_zstd}
    LD_PRELOAD=${LD_PRELOAD} make -C lib -j 1 CC=${CC} PREFIX=${dir_to_install} LIBDIR=${dir_to_install}/lib install
    LD_PRELOAD=${LD_PRELOAD} make -C lib clean

  else
    echo "  zstd-${version_zstd} already compiled -> nothing has been done."
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install hdf5-${version_hdf5}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_hdf5} = true ]; then

  if [ ! -f ${dir_to_install}/lib/libhdf5.a ]; then
  
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
  LD_PRELOAD=${LD_PRELOAD} ./configure \
              --enable-fortran \
              --enable-parallel \
              --prefix=${dir_to_install} \
              --libdir=${dir_to_install}/lib \
              --with-szlib=${dir_to_install}/include,${dir_to_install}/lib \
              CC=${CC} CFLAGS="-fPIC" FC=${FC} FCFLAGS="-fPIC" \
              LDFLAGS="-L${dir_to_install}/lib" LIBS="-lsz -laec -lz"
  LD_PRELOAD=${LD_PRELOAD} make -j 1
  LD_PRELOAD=${LD_PRELOAD} make install
  LD_PRELOAD=${LD_PRELOAD} make clean

  else
    echo "  hdf5-${version_hdf5} already compiled -> nothing has been done."
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-c-${version_netcdf_c}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_netcdf_c} = true ]; then

  if [ ! -f ${dir_to_install}/lib/libnetcdf.a ]; then

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
  LD_PRELOAD=${LD_PRELOAD} ./configure \
              --disable-nczarr \
              --disable-libxml2 \
              --disable-dap \
              --disable-byterange \
	      --enable-filter-zst \
              --prefix=${dir_to_install} \
              --libdir=${dir_to_install}/lib \
	      --with-plugin-dir=${HDF5_PLUGIN_PATH} \
              CC=${CC} CFLAGS="-fPIC" \
              CPPFLAGS="-I${dir_to_install}/include" \
              LDFLAGS="-L${dir_to_install}/lib" \
              LIBS="-lhdf5_hl -lhdf5 -lsz -laec -lzstd -lz -ldl"
  LD_PRELOAD=${LD_PRELOAD} make -j 1
  LD_PRELOAD=${LD_PRELOAD} make install
  LD_PRELOAD=${LD_PRELOAD} make clean
  
  else
    echo "  netcdf-c-${version_netcdf_c} already compiled -> nothing has been done."
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-fortran-${version_netcdf_fortran}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ${compile_netcdf_fortran} = true ]; then

  if [ ! -f ${dir_to_install}/lib/libnetcdff.a ]; then

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
  LD_PRELOAD=${LD_PRELOAD} ./configure \
              --prefix=${dir_to_install} \
              --libdir=${dir_to_install}/lib \
              CC=${CC} CFLAGS="-fPIC" FC=${FC} FCFLAGS="-fPIC" FFLAGS="-fPIC"  \
              CPPFLAGS="-I${dir_to_install}/include" \
              LDFLAGS="-L${dir_to_install}/lib" \
              LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lsz -laec -lzstd -lz -ldl"
  LD_PRELOAD=${LD_PRELOAD} make -j 1
  LD_PRELOAD=${LD_PRELOAD} make install
  LD_PRELOAD=${LD_PRELOAD} make clean

  else
    echo "  netcdf-fortran-${version_netcdf_fortran} already compiled -> nothing has been done."
  fi

fi

echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
