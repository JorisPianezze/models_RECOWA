Models for laptop_joris rst
=========================================

Compile NETCDF
-----------------------------------------

.. code-block:: bash

   source environment.sh
   cd libraries
   ./download_aec_hdf_netcdf_libraries.sh
   ./install_aer_hdf_netcdf_libraries.sh

Download models
-----------------------------------------

.. code-block:: bash

   cd ../
   ./download_models.sh

Compile CROCO without OASIS and XIOS
-----------------------------------------

.. code-block:: bash

   cd croco-v2-1-0/exe_BULK_turpan
   source ../../environment.sh
   ./jobcomp

Compile XIOS without OASIS
-----------------------------------------

.. code-block:: bash

   source environment.sh
   svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/trunk xios-3.0-trunk
   cd xios-3.0-trunk
   # Get the files in environment/turpan/compilation_xios/arch* and put it in xios-3.0-trunk/arch/
   ./make_xios --full --arch TURPAN --job 8

Compile CROCO without OASIS but with XIOS
-----------------------------------------

.. code-block:: bash

   cd croco-v2-1-0/exe_BULK_XIOS_turpan
   source ../../environment.sh
   ./jobcomp

Compile OASIS
-----------------------------------------

.. code-block:: bash

   cd oasis3-mct_5.2/util/make_dir
   make realclean -f TopMakefileOasis3
   make -f TopMakefileOasis3

Compile Meso-NH
-----------------------------------------

.. code-block:: bash

   cd MNH-V5-7-2/src
   export VER_CDF=CDFPERSO
   export VER_OASIS=OASISPERSO
   ./configure
   make -j 16
   make installmaster

Compile CROCO with OASIS but without XIOS
-----------------------------------------

.. code-block:: bash

   cd croco-v2-1-0/exe_CPLOA_turpan
   source ../../environment.sh
   ./jobcomp

Compile XIOS with OASIS
-----------------------------------------

.. code-block:: bash

   source environment.sh
   svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/trunk xios-3.0-trunk
   mv xios-3.0-trunk xios-3.0-trunk_oasis3-mct_5.2
   cd xios-3.0-trunk_oasis3-mct_5.2
   # Get the files environment/turpan/compilation_xios/arch* and put it in xios-3.0-trunk/arch/
   # Get the file environment/turpan/compilation_xios/make_xios and put it in xios-3.0-trunk/
   ./make_xios --full --arch TURPAN --use_oasis oasis3_mct --job 8

Compile CROCO with OASIS and XIOS
-----------------------------------------

.. code-block:: bash

   cd croco-v2-1-0/exe_CPLOA_XIOS_turpan
   source ../../environment.sh
   ./jobcomp
