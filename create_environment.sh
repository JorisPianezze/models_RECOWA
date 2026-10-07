#!/bin/bash

# #######################################################################
#
#   Create the environment of models_RECOWA for the current machine
#
# #######################################################################

# -----------------------------------------------------------------------
#   Always work from the models_RECOWA directory
# -----------------------------------------------------------------------

cd "$(dirname "${BASH_SOURCE[0]}")"

# -----------------------------------------------------------------------
#   Detect machine automaticaly
# -----------------------------------------------------------------------

case $(hostname) in
  belenos*)   export machine='belenos' ;;
  olympe*)    export machine='olympe' ;;
  nuwa)       export machine='nuwa' ;;
  turpan*)    export machine='turpan' ;;
  kairos*)    export machine='kairos' ;;
  datarmor*)  export machine='datarmor' ;;
  LALL224858) export machine='laptop_joris' ;;
  LELL213323) export machine='laptop_mathieu' ;;
  *)          export machine='unknown' ;;
esac

# -----------------------------------------------------------------------
#   Test presence of environment file
# -----------------------------------------------------------------------

if [ -e environment.sh ]; then
  source environment.sh
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo "   You are running on ${machine}        "
  echo "   with RECOWA version ${version_recowa}"
  echo "                                        "
  echo "   Components compatible :              "
  for comp in ${components}; do
    echo "    - ${comp}"
  done
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo "      To compile RECOWA system :        "
  echo "                                        "
  echo "    https://recowa.readthedocs.io/      "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit 1
fi

# -----------------------------------------------------------------------
#   Test that the machine is known
# -----------------------------------------------------------------------

if [ ! -e environments/${machine}/environment.sh ]; then
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo "   You are running on '${machine}'      "
  echo "   and this machine is not tested yet.  "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit 1
fi

# -----------------------------------------------------------------------
#   Create environment file
# -----------------------------------------------------------------------

sed "s|<machine>|${machine}|g" environments/common/environment.sh_tmpl > environment.sh

mkdir -p libraries ;

(
cd libraries
ln -sf ../environments/common/libraries/*.sh .
ln -sf ../environments/${machine}/compilation_libraries/*.sh .
)

# -----------------------------------------------------------------------
#   Summary
# -----------------------------------------------------------------------

source environment.sh

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "   You are running on  ${machine}       "
echo "   with RECOWA version ${version_recowa}"
echo "                                        "
echo "   Components compatible :              "
for comp in ${components}; do
  echo "    - ${comp}"
done
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "
echo "      To compile RECOWA system :        "
echo "                                        "
echo "    https://recowa.readthedocs.io/      "
echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
