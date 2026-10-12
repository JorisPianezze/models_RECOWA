.. code-block:: bash

   cd models_RECOWA_v0.1
   source environment.sh
   cd MNH-V6-0-1/src
   export VER_CDF=CDFPERSO
   export VER_OASIS=OASISPERSO
   ./configure
   . ../conf/profile_mesonh
   make -j 16
   make installmaster
