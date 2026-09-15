HSMR [![test](https://github.com/dkam/hsmr/actions/workflows/test.yml/badge.svg)](https://github.com/dkam/hsmr/actions/workflows/test.yml)
===========

HSMR is a collection of cryptographic commands usually implemented on a HSM (Hardware Security Module). These
are implemented for your education or for testing purposes and should not be used to replace an actual HSM.

Requires Ruby 3.1 or later. The only runtime dependency is the `openssl` standard library.

Installation
-------------

    gem install hsmr

Or in a Gemfile:

    gem 'hsmr'

Usage
---------

### Keys

    require 'hsmr'

    > key = HSMR::Key.new("4CA2161637D0133E5E151AEA45DA2A12")
    => 4CA2 1616 37D0 133E 5E15 1AEA 45DA 2A12
    > key.key
    => "L\xA2\x16\x167\xD0\x13>^\x15\x1A\xEAE\xDA*\x12"
    > key.to_s
    => "4CA2 1616 37D0 133E 5E15 1AEA 45DA 2A12"
    > key.kcv
    => "7B0898"

A key with no argument is generated with `SecureRandom`. Pass `HSMR::SINGLE`,
`HSMR::DOUBLE` (the default) or `HSMR::TRIPLE` for the length:

    > HSMR::Key.new(nil, HSMR::SINGLE).length
    => 8

### Components

Keys are often assembled from components held by different people. Combine them
by passing them to `Key.new`, which XORs them together:

    > c1 = HSMR::Component.new("0123456789ABCDEF")
    => 0123 4567 89AB CDEF
    > c1.kcv
    => "D5D44F"
    > c2 = HSMR::Component.new("FEDCBA9876543210")
    > key = HSMR::Key.new([c1, c2])
    => FFFF FFFF FFFF FFFF
    > key.kcv
    => "CAAAAF"

### Parity

DES keys conventionally carry odd parity in each byte. Note that parity bits do
not take part in the DES key schedule, so correcting them leaves the key check
value unchanged.

    > key = HSMR::Key.new("4CA2161637D0133E5E151AEA45DA2A12")
    > key.parity
    => "even"
    > key.odd_parity?
    => false
    > key.set_odd_parity.to_s     # modifies the key in place
    => "4CA2 1616 37D0 133E 5E15 1AEA 45DA 2A13"

### PIN blocks

    > zmk = HSMR::Key.new("0123456789ABCDEFFEDCBA9876543210")
    > block = HSMR.encrypt_pin(zmk, "041274FFFFFFFFFF")
    => "CFB709CC37D9262A"
    > HSMR.decrypt_pin(zmk, block)
    => "041274FFFFFFFFFF"

### IBM 3624 PINs

    > pgk = HSMR::Key.new("3737373737373737")
    > HSMR.ibm3624(pgk, "5560501200002101", 4, "0123456789012345").join
    => "4412"

### PVV

    > pvk = HSMR::Key.new("4CA2161637D0133E5E151AEA45DA2A12")
    > HSMR.pvv(pvk, "5999997890123412", "1", "1234")
    => "0798"

### CVV / CVV2 / CVC

    > cvk_a = HSMR::Key.new("1111111111111111")
    > cvk_b = HSMR::Key.new("1111111111111111")
    > HSMR.cvv(cvk_a, cvk_b, "5560501200002101", "1010", "0")
    => "317"
    > HSMR.cvv(cvk_a, cvk_b, "5560501200002101", "1010", "101")
    => "134"

Test vectors
------------

`doc/` holds the HSM notes and test vectors this library was built and checked
against — key check values, parity pairs, PIN block encryptions, PVV and
CVV/CVC examples. The values were produced by a real HSM, and the test suite
asserts against them.

Features
---------

* Key / Component features
  * Create Keys and Components
  * XOR Keys and Components together
  * Find Key Check Values (kcv)
  * Determine and change key parity
* Encrypt / Decrypt PIN Blocks
* Generate IBM3624 PINs
* Generate PVV, CVV & CVV2 values


Development
-----------

* Source hosted on GitHub.
* Report issues on GitHub Issues.
* Pull requests are awesome! Please include Minitest tests.

Run the suite with:

    bundle exec rake test

License
-------

The gem is available as open source under the terms of the MIT License.
