HSMR
===========

HSMR is a collection of cryptographic commands usually implemented on a HSM (Hardware Security Module). These 
are implemented for your education or for testing purposes and should not be used to replace an actual HSM.

Installation
-------------

One day I'll learn how to make gems. Until then, git clone is the only way to use this softawre.

Usage
---------

    require './lib/hsmr'
    require './lib/key'
    require './lib/component'

    # Create a Key
    > key=HSMR::Key.new("4CA2161637D0133E5E151AEA45DA2A12")
    => 4CA2 1616 37D0 133E 5E15 1AEA 45DA 2A12 
    > key.key
    => "L\xA2\x16\x167\xD0\x13>^\x15\x1A\xEAE\xDA*\x12" 
    > key.to_s
    => "4CA2 1616 37D0 133E 5E15 1AEA 45DA 2A12" 
    > key.kcv
    => "7B0898" 
    > key.parity
    => "odd" 
  
    # Generate a PVV

    pan="5999997890123412"
    pin="1234"
    pvki="1"
    pvv = HSMR.pvv(key, pan, pvki, pin)
    => "0798"

Features
---------

* Key / Componet features
** Create Keys and Components
** XOR Keys and Components together
** Find Key Check Values (kcv)
** Determine and change key parity



Author
==========

Dan Milne, http://da.nmilne.com

Copyright
----------

Copyright (c) 2010 Dan Milne. See LICENSE for details.
