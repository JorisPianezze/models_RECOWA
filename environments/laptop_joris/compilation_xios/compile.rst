* To compile XIOS without OASIS

  .. code-block:: bash

     cd models_YOURPROJECT
     source environment.sh
     cd libraries/xios-3.0.6.0
     ./make_xios --full --arch ${machine} --job 2

* To compile XIOS with OASIS

  .. code-block:: bash

     cd models_YOURPROJECT
     source environment.sh
     cd libraries/xios-3.0.6.0_oasis3-mct_5.2
     ./make_xios --full --arch ${machine} --use_oasis oasis3_mct --job 2
