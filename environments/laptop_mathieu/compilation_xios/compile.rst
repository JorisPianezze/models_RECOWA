* To compile XIOS without OASIS

  .. code-block:: bash

     cd models_RECOWA_v0.1
     source environment.sh
     cd libraries/xios-3.0-3.0.6.0
     ./make_xios --full --arch ${machine} --job 2
