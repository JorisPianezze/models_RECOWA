#!/bin/bash

# ---------------------------------------
#   Detect machine automaticaly
# ---------------------------------------

if [[ ${HOSTNAME} = 'belenos'* ]]; then

  export machine='belenos'

elif [[ ${HOSTNAME} = 'olympe'* ]]; then

  export machine='olympe'

elif [[ ${HOSTNAME} = 'nuwa' ]]; then

  export machine='nuwa'

elif [[ ${HOSTNAME} = 'turpan'* ]]; then

  export machine='turpan'

elif [[ ${HOSTNAME} = 'kairos'* ]]; then

  export machine='kairos'

elif [[ ${HOSTNAME} = 'LALL224858' ]]; then
 
  export machine='laptop_joris'

elif [[ ${HOSTNAME} = 'datarmor'* ]]; then

  export machine='datarmor'

else

  export machine='unknown'

fi

# ---------------------------------------
#   Test presence of environment file
# ---------------------------------------

if [ -e environment.sh ]; then
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  echo "   You've already set your environment  "
  echo "      ~ Nothing has been done ~         "
  echo "                                        "
  echo "      To compile RECOWA system :        "
  echo "                                        "
  echo "    https://recowa.readthedocs.io/      "
  echo "                                        "
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
  exit
fi

# ---------------------------------------
#   Link environment file
# ---------------------------------------

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
if [ -e environments/${machine}/environment.sh ]; then
  echo "  You are running on '${machine}' with "
  echo "       following environment :         "
  echo "                                       "
  cp environments/${machine}/environment.sh .
  sed -i "s|path_to_models_directory|${PWD}|g" environment.sh
  cat environment.sh

  ln -sf environments/common/download_models.sh .

  mkdir libraries ; cd libraries
  ln -sf ../environments/common/libraries/*.sh .
  ln -sf ../environments/${machine}/compilation_libraries/*.sh .

else
  echo "  You are running on '${machine}' and"
  echo "  this machine is not tested yet     "
fi

echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
echo "                                        "
echo "      To compile RECOWA system :        "
echo "                                        "
echo "    https://recowa.readthedocs.io/      "
echo "                                        "
echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
