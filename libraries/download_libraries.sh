#!/bin/bash

# #######################################################################
#
#                         J. Pianezze
#          Download AEC, HDF5 and NetCDF libraries sources
#        (versions fixed in versions.sh, common to all machines)
#
#   To be run on a node with internet access (login node on clusters)
#
# #######################################################################

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Always work from the libraries directory
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ ! -e ../environment.sh ]; then
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo "  environment.sh file is missing        "
  echo "  -> run ./create_environment.sh first  "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit 1
else
  source ../environment.sh
fi

machine_dir=../environments/${machine}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Internal function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

is_enabled() {
  [[ " ${components} " == *" $1 "* ]]
}

download() {
  local archive=$1
  local url=$2
  if [ -e ${archive} ]; then
    echo "  ${archive} exists -> nothing has been done."
  else
    wget --no-check-certificate -O ${archive} ${url}
  fi
}

copy_machine_files() {
  local src=$1
  local dst=$2
  shift 2
  for file in "$@"; do
    cp -R ${src}/${file} ${dst}/
    if [ -f ${dst}/${file} ]; then
      sed -i "s|path_to_models_directory|${models_recowa_dir}|g" ${dst}/${file}
    fi
  done
}

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download libraries for NetCDF
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

download zstd-${version_zstd}.tar.gz \
  https://github.com/facebook/zstd/releases/download/v${version_zstd}/zstd-${version_zstd}.tar.gz

download libaec-${version_libaec}.tar.gz \
  https://github.com/MathisRosenhauer/libaec/releases/download/v${version_libaec}/libaec-${version_libaec}.tar.gz

download hdf5-${version_hdf5}.tar.gz \
  https://github.com/HDFGroup/hdf5/releases/download/hdf5_${version_hdf5}/hdf5-${version_hdf5}.tar.gz

download netcdf-c-${version_netcdf_c}.tar.gz \
  https://github.com/Unidata/netcdf-c/archive/refs/tags/v${version_netcdf_c}.tar.gz

download netcdf-fortran-${version_netcdf_fortran}.tar.gz \
  https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${version_netcdf_fortran}.tar.gz

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download oasis3-mct_${version_oasis}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if is_enabled oasis; then

  oasis_dir=oasis3-mct_${version_oasis}

  if [ ! -d ${oasis_dir} ]; then
    git clone --depth 1 --branch OASIS3-MCT_${version_oasis} https://gitlab.com/cerfacs/oasis3-mct.git ${oasis_dir}
    copy_machine_files ${machine_dir}/compilation_oasis ${oasis_dir}/util/make_dir make.inc make.${machine}
  else
    echo "  ${oasis_dir} directory already exists -> nothing has been done."
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download xios-${version_xios}  
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if is_enabled xios; then

  xios_dir=xios-${version_xios}

  if [ ! -d ${xios_dir} ]; then
    git clone --depth 1 --branch xios-${version_xios} https://gitlab.in2p3.fr/ipsl/projets/xios-projects/xios.git ${xios_dir}
    copy_machine_files ${machine_dir}/compilation_xios ${xios_dir}/arch arch-${machine}.env arch-${machine}.fcm arch-${machine}.path
    sed -i 's|^\([[:space:]]*NETCDF_LIB="-lnetcdff -lnetcdf"\)|#\1|' ${xios_dir}/make_xios
  else
    echo "  ${xios_dir} directory already exists -> nothing has been done."
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download xios-${version_xios}_oasis3-mct_${version_oasis}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if is_enabled xios_oasis; then

  xios_oasis_dir=xios-${version_xios}_oasis3-mct_${version_oasis}

  if [ ! -d ${xios_oasis_dir} ]; then
    git clone --depth 1 --branch xios-${version_xios} https://gitlab.in2p3.fr/ipsl/projets/xios-projects/xios.git ${xios_oasis_dir}
    copy_machine_files ${machine_dir}/compilation_xios ${xios_oasis_dir}/arch arch-${machine}.env arch-${machine}.fcm arch-${machine}.path
    sed -i 's|^\([[:space:]]*NETCDF_LIB="-lnetcdff -lnetcdf"\)|#\1|' ${xios_oasis_dir}/make_xios
  else
    echo "  ${xios_oasis_dir} directory already exists -> nothing has been done."
  fi

fi

echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
