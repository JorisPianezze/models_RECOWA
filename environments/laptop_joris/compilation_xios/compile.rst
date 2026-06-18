* Compile XIOS without OASIS

  .. code-block:: bash

     source environment.sh
     svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/trunk xios-3.0-trunk
     cd xios-3.0-trunk
     # Get the files in environment/turpan/compilation_xios/arch* and put it in xios-3.0-trunk/arch/
     ./make_xios --full --arch TURPAN --job 8

* Compile XIOS with OASIS

  .. code-block:: bash

     source environment.sh
     svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/trunk xios-3.0-trunk
     mv xios-3.0-trunk xios-3.0-trunk_oasis3-mct_5.2
     cd xios-3.0-trunk_oasis3-mct_5.2
     # Get the files environment/turpan/compilation_xios/arch* and put it in xios-3.0-trunk/arch/
     # Get the file environment/turpan/compilation_xios/make_xios and put it in xios-3.0-trunk/
     ./make_xios --full --arch TURPAN --use_oasis oasis3_mct --job 8
