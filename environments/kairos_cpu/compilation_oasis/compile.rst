.. code-block:: bash

   cd models_RECOWA_v0.1/
   source environment.sh
   cd libraries/oasis3-mct_5.2/util/make_dir
   LD_PRELOAD=${LD_PRELOAD} make realclean -f TopMakefileOasis3
   LD_PRELOAD=${LD_PRELOAD} make -f TopMakefileOasis3
