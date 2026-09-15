## v0.0.1

* Initial release
* Key / Componet features
  * Create Keys and Components
  * XOR Keys and Components together
  * Find Key Check Values (kcv)
  * Determine and change key parity
* Encrypt / Decrypt PIN Blocks
* Generate IBM3624 PINs
* Generate PVV, CVV & CVV2 values

## v0.1.0

* Fix single DES on OpenSSL 3 — `des-cbc` moved to the legacy provider, so
  single length keys are now run through `des-ede3` with K1=K2=K3, which is
  equivalent. `kcv` on single length keys and `ibm3624` raised
  `OpenSSL::Cipher::CipherError` before this.
* `Key.new` now raises `TypeError` on input it can't use. It previously
  returned a freshly generated random key instead.
* `Key.new` with several components works — it raised `NoMethodError` before.
* `Key.new([])` raises `ArgumentError` rather than returning an unusable object.
* `Key.new` no longer mutates the array of components passed to it.
* Keys and components are generated with `SecureRandom` rather than `Kernel#rand`.
* Fix `odd_parity?` — it only inspected the first byte of the key, so keys
  with an odd first byte and even bytes later were reported as odd parity and
  left alone by `set_odd_parity`.
* Fix `parity`, which always returned `'odd'`.
* Fix `cvv` for PANs that aren't 16 digits. The PAN, expiry and service code
  are now concatenated and zero padded to 32 digits before being split, rather
  than assuming the PAN fills the first half.
* Add the HSM test vectors these were found with under `doc/`.
* Move the test suite from Test::Unit to Minitest, and declare `minitest`
  as a development dependency. The suite previously required `test/unit`
  but only got it transitively via `guard-test`.
* Stop committing `Gemfile.lock` (it was already in `.gitignore`, and a
  library should not pin its dependencies).
* Correct the `parity` example in the README, which recorded the buggy output.
* Remove Guard. The Guardfile was unmodified boilerplate and `guard-test`
  was the only thing dragging in a dependency tree.
