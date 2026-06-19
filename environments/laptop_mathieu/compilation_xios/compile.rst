* To compile XIOS without OASIS

  .. code-block:: bash

     cd models_YOURPROJECT
     source environment.sh
     cd xios-3.0-trunk/
     ./make_xios --full --arch ${machine} --job 2

* To compile XIOS with OASIS

  .. code-block:: bash

     cd models_YOURPROJECT
     source environment.sh
     cd xios-3.0-trunk_oasis3-mct_5.2
     # Comment the line 223 : # NETCDF_LIB="-lnetcdff -lnetcdf" 
     ./make_xios --full --arch ${machine} --use_oasis oasis3_mct --job 2
