.. code-block:: bash

   cd models_YOURPROJECT
   source environment.sh
   cd MNH-V6-0-0/src
   export VER_MPI=MPIAUTO
   export VER_CDF=CDFPERSO
   export VER_OASIS=OASISPERSO
   ./configure
   . ../conf/profile_mesonh
   make -j 2
   make installmaster
