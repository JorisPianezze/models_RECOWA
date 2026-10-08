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

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download create_rmp_files_for_oasis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ! -d create_rmp_files_for_oasis ]; then
  git clone --depth 1 --branch v${version_create_rmp_files_for_oasis} https://github.com/JorisPianezze/create_rmp_files_for_oasis.git
else
  echo "  create_rmp_files_for_oasis directory already exists -> nothing has been done."
fi

echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
