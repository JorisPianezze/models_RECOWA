#!/bin/bash

# #######################################################################
#
#                         J. Pianezze
#               Download OASIS, XIOS, Meso-NH, CROCO,
#                       WW3 and WRF models
#
#     Only components listed in environments/<machine>/environment.sh are
#     downloaded, at the versions fixed in versions.sh.
#
# #######################################################################

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Always work from the models_RECOWA directory
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ ! -e environment.sh ]; then
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo "  environment.sh file is missing        "
  echo "  -> run ./create_environment.sh first  "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit 1
else
  source environment.sh
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Internal functions & environment variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

is_enabled() {
  [[ " ${components} " == *" $1 "* ]]
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

machine_dir=environments/${machine}

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download MNH_V${version_mesonh}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if is_enabled mesonh; then

  mesonh_dir=MNH-V${version_mesonh}

  if [ ! -d ${mesonh_dir} ]; then
    git clone --depth 1 --branch PACK-MNH-V${version_mesonh} https://src.koda.cnrs.fr/mesonh/mesonh-code.git ${mesonh_dir}
    copy_machine_files ${machine_dir}/compilation_mesonh ${mesonh_dir}/src configure
    sed -i '/^[[:space:]]*export HDF5_PLUGIN_PATH=.*hdf5_plugins/ s|^|#|' MNH-V6-0-1/conf/profile_mesonh.ihm
  else
    echo "  ${mesonh_dir} directory already exists -> nothing has been done."
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download croco-v${version_croco}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if is_enabled croco; then
 
  croco_dir=croco-v${version_croco}
 
  if [ ! -d ${croco_dir} ]; then
    git clone --depth 1 --branch v${version_croco} https://gitlab.inria.fr/croco-ocean/croco.git ${croco_dir}
    cp -R ${machine_dir}/compilation_croco/exe_CPLOA_NOXIOS ${croco_dir}/
    cp -R ${machine_dir}/compilation_croco/exe_CPLOA_XIOS   ${croco_dir}/
    sed -i "s|path_to_models_directory|${models_recowa_dir}/croco-v${version_croco}|g" ${croco_dir}/exe_CPLOA_NOXIOS/jobcomp
    sed -i "s|path_to_models_directory|${models_recowa_dir}/croco-v${version_croco}|g" ${croco_dir}/exe_CPLOA_XIOS/jobcomp
  else
    echo '  croco-v'${version_croco}' directory already exists -> nothing has been done.'
  fi
 
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download ww3-v${version_ww3}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if is_enabled ww3; then

  ww3_dir=WW3-v${version_ww3}

  if [ ! -d ${ww3_dir} ]; then
    git clone https://github.com/NOAA-EMC/WW3 ${ww3_dir}
    if [ -z "${commit_ww3}" ]; then
      echo "  WARNING : commit_ww3 not set in versions.sh -> default branch"
    else
      git -C ${ww3_dir} checkout ${commit_ww3}
    fi
    copy_machine_files ${machine_dir}/compilation_ww3 ${ww3_dir}/model/bin \
        cmplr.env link.tmpl w3_setup w3_make switch_NOOASIS switch_OASACM_OASOCM
  else
    echo '  WW3-v'${version_ww3}' directory already exists -> nothing has been done.'
  fi

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download wrf-crocov${version_wrf}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if is_enabled wrf; then

  wrf_dir=wrf-crocov${version_wrf}

  if [ ! -d ${wrf_dir} ]; then
    git clone --depth 1 --branch wrf-crocov${version_wrf} https://github.com/wrf-croco/WRF.git ${wrf_dir}
  else
    echo '  wrf-crocov'${version_wrf}' directory already exists -> nothing has been done.'
  fi

fi

echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "
echo "      To compile RECOWA system :        "
echo "                                        "
echo "    https://recowa.readthedocs.io/      "
echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "

