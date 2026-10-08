#!/bin/bash

# #######################################################################
#
#   Create the environment of models_RECOWA for the current machine
#
# #######################################################################

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Always work from the models_RECOWA directory
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cd "$(dirname "${BASH_SOURCE[0]}")"

print_next_steps() {

  local step=1

  echo "   Next steps :                                      "
  echo "                                                     "
  echo "   ${step}. Load the environment (each new session) :"
  echo "        source environment.sh                        "
  echo "                                                     "
  step=$((step+1))

  if [[ " ${components} " == *" libraries "* ]]; then
    echo "   ${step}. Download and compile the libraries :"
    echo "        cd libraries                            "
    echo "        ./download_libraries.sh                 "
    if [ -n "${slurm_options}" ]; then
      echo "        sbatch ${slurm_options} compile_libraries.sh"
    else
      echo "        ./compile_libraries.sh                "
    fi
    echo "        cd ..                                   "
    echo "                                                "
    step=$((step+1))
  fi

  echo "   ${step}. Download the models :"
  echo "        ./download_models.sh     "
  echo "                                 "
  step=$((step+1))

  echo "   ${step}. Compile the models, following the documentation :    "
  echo "        https://recowa.readthedocs.io/                           "
  echo "        ($(echo ${components} | sed 's/\blibraries\b//' | xargs))"
  echo "                                                                 "
  step=$((step+1))

  echo "   ${step}. Check the installation :"
  echo "        ./check_install.sh          "
  echo "                                    "
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Detect machine automaticaly
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Test presence of environment file
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ -e environment.sh ]; then
  source environment.sh
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo "   You are running on ${machine}        "
  echo "        RECOWA version ${version_recowa}"
  echo "                                        "
  echo "   Components compatible :              "
  for comp in ${components}; do
    echo "    - ${comp}"
  done
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  print_next_steps
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit 1
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Test that the machine is known
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ ! -e environments/${machine}/environment.sh ]; then
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "                                        "
  echo "   You are running on '${machine}'      "
  echo "   and this machine is not tested yet.  "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit 1
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Create environment file
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sed "s|<machine>|${machine}|g" environments/common/environment.sh_tmpl > environment.sh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Summary
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
print_next_steps
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "

