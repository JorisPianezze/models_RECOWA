#!/bin/bash

# #######################################################################
#
#                         J. Pianezze
#             Check the installation of models_RECOWA
#
#   Nothing is compiled : only checks that the libraries and codes listed
#   in 'components' (environments/<machine>/environment.sh) are installed
#   at the versions fixed in versions.sh.
#
# #######################################################################

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Always work from the models_RECOWA directory
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

nb_ok=0
nb_warn=0
nb_fail=0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Functions : display
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ok()    { printf "  [ OK ]  %s\n" "$1" ; nb_ok=$((nb_ok+1)) ; }
warn()  { printf "  [WARN]  %s\n" "$1" ; nb_warn=$((nb_warn+1)) ; }
fail()  { printf "  [FAIL]  %s\n" "$1" ; nb_fail=$((nb_fail+1)) ; }
info()  { printf "  [INFO]  %s\n" "$1" ; }
title() { printf "\n ~~~ %s ~~~\n" "$1" ; }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Functions : checks
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Is the component enabled on this machine ?
is_enabled() {
  [[ " ${components} " == *" $1 "* ]]
}

# File (or pattern) exists
#   usage : check_file <pattern> <label>
check_file() {
  if ls $1 > /dev/null 2>&1; then
    ok "$2"
  else
    fail "$2 (missing : $1)"
  fi
}

# Directory exists ; returns 1 otherwise (to skip the following checks)
#   usage : check_dir <directory>
check_dir() {
  if [ -d "$1" ]; then
    ok "directory $(basename $1)"
    return 0
  else
    fail "missing directory : $1"
    return 1
  fi
}

# Executable found somewhere in a directory
#   usage : check_exe <directory> <executable>
check_exe() {
  if [ -n "$(find $1 -name $2 -type f -perm -u+x 2>/dev/null | head -1)" ]; then
    ok "$2"
  else
    fail "$2 (not found in $1)"
  fi
}

# Git tag of a code matches the expected one
#   usage : check_git_tag <directory> <expected_tag>
check_git_tag() {
  local tag=$(git -C $1 describe --tags --exact-match 2>/dev/null)
  if [ -z "${tag}" ]; then
    tag=$(git -C $1 describe --tags 2>/dev/null)
  fi
  if [ "${tag}" == "$2" ]; then
    ok "version : ${tag}"
  else
    warn "version : '${tag}' (expected : $2)"
  fi
}

# Git commit of a code matches the expected one (short hash accepted)
#   usage : check_git_commit <directory> <expected_commit>
check_git_commit() {
  if [ -z "$2" ]; then
    warn "expected commit not set in versions.sh"
    return
  fi
  local commit=$(git -C $1 rev-parse HEAD 2>/dev/null)
  if [[ "${commit}" == "$2"* ]]; then
    ok "commit : ${commit:0:10}"
  else
    warn "commit : ${commit:0:10} (expected : $2)"
  fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Header
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "  models_RECOWA v${version_recowa}"
echo "  Machine    : ${machine}"
echo "  Components : ${components}"
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Version of the models_RECOWA repository
#     - git tag (vX.Y.Z or X.Y.Z) consistent with version_recowa (X.Y)
#     - versions.sh not modified locally
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "models_RECOWA repository"
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then

  info "branch : $(git rev-parse --abbrev-ref HEAD)"

  git_tag=$(git describe --tags --abbrev=0 2>/dev/null)
  if [ -z "${git_tag}" ]; then
    warn "no git tag found, cannot check version_recowa=${version_recowa}"
  else
    tag_major_minor=$(echo ${git_tag#v} | cut -d. -f1,2)
    if [ "${tag_major_minor}" == "${version_recowa}" ]; then
      ok "tag ${git_tag} consistent with version_recowa=${version_recowa}"
    else
      warn "tag ${git_tag} inconsistent with version_recowa=${version_recowa} (versions.sh)"
    fi
    nb_commits=$(git rev-list ${git_tag}..HEAD --count)
    if [ ${nb_commits} -gt 0 ]; then
      info "${nb_commits} commit(s) since ${git_tag}"
    fi
  fi

  if git diff --quiet HEAD -- versions.sh; then
    ok "versions.sh not modified locally"
  else
    warn "versions.sh modified locally (git diff versions.sh)"
  fi

else
  info "not a git repository, version not checked"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Compilation environment
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "Compilation environment"
for cmd in ${CC} ${FC}; do
  if command -v ${cmd} > /dev/null 2>&1; then
    ok "${cmd} -> $(command -v ${cmd})"
  else
    fail "${cmd} not found in PATH (check environments/${machine}/env.sh)"
  fi
done
if command -v ${FC} > /dev/null 2>&1; then
  info "$(${FC} --version 2>/dev/null | head -1)"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Libraries (libaec, HDF5, NetCDF)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "Netcdf"
if is_enabled netcdf; then

  dir_libs=$(dirname $(dirname ${NETCDF_CONFIG}))

  if check_dir ${dir_libs}; then

    # libaec
    check_file "${dir_libs}/lib/libaec.so" "libaec.so"
    check_file "${dir_libs}/lib/libsz.so"  "libsz.so"

    # zstd
    check_file "${dir_libs}/lib/libzstd.so" "libzstd.a"

    # HDF5
    check_file "${dir_libs}/lib/libhdf5.so" "libhdf5.so"

    # NetCDF-C
    check_file "${HDF5_PLUGIN_PATH}/lib__nch5zstd.so" "lib__nch5zstd.so"

    # NetCDF-Fortran
    if [ -x "${NETCDF_CONFIG}" ]; then
      nf_version=$(${NETCDF_CONFIG} --version | awk '{print $NF}')
      if [ "${nf_version}" == "${version_netcdf_fortran}" ]; then
        ok "netcdf-fortran ${nf_version}"
      else
        fail "netcdf-fortran ${nf_version} (expected : ${version_netcdf_fortran})"
      fi
    else
      fail "nf-config missing : ${NETCDF_CONFIG}"
    fi

  fi

else
  info "not enabled on ${machine}"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   OASIS3-MCT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "OASIS3-MCT ${version_oasis}"
if is_enabled oasis; then

  oasis_dir=${models_recowa_dir}/libraries/oasis3-mct_${version_oasis}

  if check_dir ${oasis_dir}; then
    check_git_tag ${oasis_dir} OASIS3-MCT_${version_oasis}
    if check_dir ${OASISDIR}; then
      for lib in libpsmile.MPI1.a libmct.a libmpeu.a libscrip.a; do
        check_file "${OASISDIR}/lib/${lib}" "${lib}"
      done
      if [ -n "$(find ${OASISDIR} -name mod_oasis.mod 2>/dev/null | head -1)" ]; then
        ok "mod_oasis.mod"
      else
        fail "mod_oasis.mod (not found in ${OASISDIR})"
      fi
    fi
  fi

else
  info "not enabled on ${machine}"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   XIOS : 4 possible variants
#     usage : check_xios <label> <directory> <svn|git>
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "XIOS ${version_xios}"
if is_enabled xios; then

  xios_dir=${models_recowa_dir}/libraries/xios-${version_xios}

  if check_dir ${xios_dir}; then
    check_git_tag ${xios_dir} xios-${version_xios}
    if check_dir ${XIOS_DIR}; then
      check_file "${XIOS_DIR}/lib/libxios.a" "libxios.a"
      check_file "${XIOS_DIR}/inc/xios.mod" "xios.mod"
      check_file "${XIOS_DIR}/bin/xios_server.exe" "xios_server.exe"
    fi
  fi

else
  info "not enabled on ${machine}"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Meso-NH
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "Meso-NH ${version_mesonh}"
if is_enabled mesonh; then

  mesonh_dir=${models_recowa_dir}/MNH-V${version_mesonh}

  if check_dir ${mesonh_dir}; then
    check_git_tag ${mesonh_dir} PACK-MNH-V${version_mesonh}
    check_file "${mesonh_dir}/src/configure" "src/configure (machine file)"
    check_file "${mesonh_dir}/conf/profile_mesonh-*" "profile_mesonh"
    for profile in ${mesonh_dir}/conf/profile_mesonh-*; do
      [ -f "${profile}" ] && info "$(basename ${profile})"
    done
    for exe in PREP_PGD PREP_REAL_CASE MESONH; do
      check_file "${mesonh_dir}/exe/${exe}-*" "${exe}"
    done
  fi

else
  info "not enabled on ${machine}"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   CROCO (compiled for each configuration in config_RECOWA)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "CROCO ${version_croco}"
if is_enabled croco; then

  croco_dir=${models_recowa_dir}/croco-v${version_croco}

  if check_dir ${croco_dir}; then
    check_git_tag ${croco_dir} v${version_croco}
    for exe_dir in exe_CPLOA_NOXIOS exe_CPLOA_XIOS; do
      check_file "${croco_dir}/${exe_dir}/croco" "${exe_dir}/croco"
    done
    info "CROCO is compiled for each configuration"
  fi

else
  info "not enabled on ${machine}"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   WW3
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "WW3 ${version_ww3}"
if is_enabled ww3; then

  ww3_dir=${models_recowa_dir}/WW3-v${version_ww3}

  if check_dir ${ww3_dir}; then
    check_git_commit ${ww3_dir} "${commit_ww3}"
    for exe in ww3_grid ww3_strt ww3_prnc ww3_shel ww3_ounf; do
      check_exe ${ww3_dir} ${exe}
    done
  fi

else
  info "not enabled on ${machine}"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   WRF (wrf-croco)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
title "WRF ${version_wrf}"
if is_enabled wrf; then

  wrf_dir=${models_recowa_dir}/wrf-crocov${version_wrf}

  if check_dir ${wrf_dir}; then
    check_git_tag ${wrf_dir} wrf-crocov${version_wrf}
    for exe in real.exe wrf.exe; do
      check_exe ${wrf_dir}/main ${exe}
    done
  fi

else
  info "not enabled on ${machine}"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Summary
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "  ${nb_ok} OK, ${nb_warn} warning(s), ${nb_fail} failure(s)"
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "

if [ ${nb_fail} -gt 0 ]; then exit 1; fi
exit 0
