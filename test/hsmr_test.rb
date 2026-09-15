require 'test_helper'

class TestHSMR < Minitest::Test

  def test_generate_a_component 
	  component_1 = HSMR::Component.new(nil, HSMR::SINGLE)
	  component_2 = HSMR::Component.new(nil, HSMR::DOUBLE)
	  component_3 = HSMR::Component.new(nil, HSMR::TRIPLE)	  	

	  assert_equal 8,  component_1.length
    assert_equal 16, component_2.length
    assert_equal 24, component_3.length
  end

  def test_caclulation_of_single_length_component_KCV_values
    component_1 = HSMR::Component.new("6DBF C180 4A01 5BAD")
    assert_equal "029E60", component_1.kcv

    component_2 = HSMR::Component.new("5D80 0497 B319 8591")
    assert_equal "3B86C3", component_2.kcv

    component_3 = HSMR::Component.new("B0C7 7CDC 7354 97C7")
    assert_equal "7A77BC", component_3.kcv

    component_4 = HSMR::Component.new("DAE0 86FE D6EA 0BEA")
    assert_equal "2E6191", component_4.kcv

    component_5 = HSMR::Component.new("682C 8315 F4BF FBC1")
    assert_equal "62B336", component_5.kcv

    component_6 = HSMR::Component.new("5715 F289 04BC B62F")
    assert_equal "3CBA88", component_6.kcv

    component_7 = HSMR::Component.new("D0C4 29AE C4A8 02B5")
    assert_equal "33AF02", component_7.kcv

    component_8 = HSMR::Component.new("7049 D0F7 4A97 15B6")
    assert_equal "AC1399", component_8.kcv

    component_9 = HSMR::Component.new("BC91 D698 157A A4E5")
    assert_equal "295491", component_9.kcv

    component_10 = HSMR::Component.new("64AB 8568 7A0E 322F")
    assert_equal  "D9F7B3", component_10.kcv
  end

  def test_should_calculate_double_length_key_KCV_values
    key_1 = HSMR::Key.new("ADE3 9B38 0DBC DF38 AE02 AECE 64B3 4373")
    assert_equal "3002D5", key_1.kcv

    key_2 = HSMR::Key.new("B64A EF86 460D DF5B 57B3 D53D AD37 52A1")
    assert_equal "1F7C07", key_2.kcv

    key_3 = HSMR::Key.new("5B89 6E29 76EC 9745 15B5 238C 8CFE 3D23")
    assert_equal "DE78F2", key_3.kcv

    key_4 = HSMR::Key.new("5E61 CB20 D540 1FC7 58EC CDC8 B558 E9B9")
    assert_equal "FED957", key_4.kcv

    key_5 = HSMR::Key.new("23DF CEB9 BF94 ADA8 91E9 580B 8C8F 5BEF")
    assert_equal "902085", key_5.kcv

    key_6 = HSMR::Key.new("DFEF 61C8 2037 3DA4 CE9B 92CD 89E9 B334")
    assert_equal "E45EB7", key_6.kcv

    key_7 = HSMR::Key.new("6746 9E4C FE83 F831 F23E 9D9E 9D9E 9DB3")
    assert_equal "813B7B", key_7.kcv

    key_8 = HSMR::Key.new("23E5 496E DF94 0BD5 9734 B07A BF26 B9E6")
    assert_equal "E7C48F", key_8.kcv

    key_9 = HSMR::Key.new("974F 26BC CB2A ECD5 434F 1CDC 64DF A275")
    assert_equal "E27250", key_9.kcv

    key_10 = HSMR::Key.new("E57A DF5B CEA7 F42A DFD9 E554 07A2 F891")
    assert_equal "50E3F8", key_10.kcv
  end

  def test_should_detect_odd_parity_in_a_key
    parity=[]
    #            Odd              Even
    parity << %W{ 0123456789ABCDEF 0022446688AACCEE }
    parity << %W{ FEDCBA9876543210 FFDDBB9977553311 }
    parity << %W{ 89ABCDEF01234567 88AACCEE00224466 }
    parity << %W{ 40A2AD15A80D583740A2AD15A80D5837 41A2AC14A90C583741A2AC14A90C5837 }

    # Test determining the parity
    parity.each do |pair|
      assert HSMR::Key.new(pair[0]).odd_parity?
      refute HSMR::Key.new(pair[1]).odd_parity?

      assert HSMR::Component.new(pair[0]).odd_parity?
      refute HSMR::Component.new(pair[1]).odd_parity?
    end

    # Test converting even to odd parity
    parity.each do |pair|
      odd_key = HSMR::Key.new(pair[0])
      even_key = HSMR::Key.new(pair[0])
      
      even_key.set_odd_parity
      assert_equal odd_key,  odd_key
    end
  end
  
  def test_converting_string_to_ascii_works
    key_string = "E57A DF5B CEA7 F42A DFD9 E554 07A2 F891"
    key = HSMR::Key.new(key_string)

    assert_equal key.to_s, key_string 

    key_string = "E57A DF5B CEA7 F42A DFD9 E554 07A2 F891"
    comp = HSMR::Component.new(key_string)

    assert_equal comp.to_s, key_string 
  end

  def test_CVC_CVC2_calculations
    # doc/CVC.examples.txt. This test previously built the table below and then
    # asserted nothing at all.
    ka = HSMR::Key.new("1234567890ABCDEF")
    kb = HSMR::Key.new("FEDCBA1234567890")

              #  PAN                 EXP  SCode CVC
    cases = []
    cases << %W{ 5656565656565656    1010 ""    922 }
    cases << %W{ 5656565656565656    1010 000   922 }
    cases << %W{ 5683739237489383838 1010 000   367 }
    cases << %W{ 568367393472639     1010 000   067 }
    cases << %W{ 5683673934726394    1010 000   409 }
    cases << %W{ 5683673934726394    1010 050   248 }
    cases << %W{ 5683673934726394    1010 101   501 }
    cases << %W{ 5683673934726394    1010 102   206 }

    cases.each do |pan, exp, svc, expected|
      svc = "" if svc == %q{""}
      assert_equal expected, HSMR::cvv(ka, kb, pan, exp, svc),
                   "PAN #{pan} (#{pan.length} digits), service code #{svc.inspect}"
    end
  end

  def test_PIN_PVV_CVV_and_CVV2_generation
    cases=[]
    #            Account          Exp  PIN  PVV  CVV2 CVV PGK1             PGK2             PVKI PVK1             PVK2             CVKA             CVKB             DEC
    #            0                1    2    3    4    5    6                7                8    9                10               11               12               13 
    cases << %W{ 5560501200002101 1010 4412 6183 134  317 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002111 1010 4784 0931 561  924 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002121 1010 1040 4895 462  673 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002131 1010 3680 6373 826  267 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002101 1110 4412 6183 900  155 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002111 1110 4784 0931 363  513 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002121 1110 1040 4895 952  937 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002131 1110 3680 6373 667  522 3737373737373737 0000000000000000 2    1111111111111111 1111111111111111 1111111111111111 1111111111111111 0123456789012345}
    cases << %W{ 5560501200002101 1010 9907 7527 777  473 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}
    cases << %W{ 5560501200002111 1010 2345 0658 638  553 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}
    cases << %W{ 5560501200002121 1010 8245 8196 085  480 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}
    cases << %W{ 5560501200002131 1010 3812 2948 591  546 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}
    cases << %W{ 5560501200002101 1110 9907 7527 349  994 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}
    cases << %W{ 5560501200002111 1110 2345 0658 245  266 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}
    cases << %W{ 5560501200002121 1110 8245 8196 441  115 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}
    cases << %W{ 5560501200002131 1110 3812 2948 126  768 0123456789ABCDEF FEDCBA9876543210 2    7BB19E3D56A1237E 29F7C8FA379EE25C 007A5048DB9531B3 0322DA78AB2F85E1 0123456789012345}

    cases.each do |c|
      ibm1=HSMR::Component.new(c[6])
      ibm2=HSMR::Component.new(c[7])
      ibm=ibm1.xor(ibm2)
      
      pvk=HSMR::Key.new(c[9]+c[10])
      
      pin = HSMR::ibm3624(ibm, c[0], 4, c[13]).join
      pvv = HSMR::pvv(pvk, c[0], c[8], pin)

      assert_equal pin, c[2]
      assert_equal pin.to_i, c[2].to_i
      assert_equal pvv, c[3]
      assert_equal pvv.to_i, c[3].to_i

      cvv = HSMR::cvv(HSMR::Key.new(c[11]),  HSMR::Key.new(c[12]), c[0], c[1], '0')
      cvv2 = HSMR::cvv(HSMR::Key.new(c[11]),  HSMR::Key.new(c[12]), c[0], c[1], '101')

      assert_equal c[4].to_i, cvv2.to_i
      assert_equal c[5].to_i, cvv.to_i

      #puts "#{pin} == #{c[2]} ? #{pin.to_i == c[2].to_i} | #{pvv} == #{c[3]} ? #{pvv.to_i == c[3].to_i}"
    end
  end
  def test_key_rejects_unusable_input
    # Previously any unexpected type silently returned a freshly generated
    # random key rather than raising.
    assert_raises(TypeError)     { HSMR::Key.new(123) }
    assert_raises(TypeError)     { HSMR::Key.new(:oops) }
    assert_raises(TypeError)     { HSMR::Component.new(123) }
    assert_raises(ArgumentError) { HSMR::Key.new([]) }
  end

  def test_key_generates_a_usable_key_when_given_nothing
    key = HSMR::Key.new
    assert_equal 16, key.length
    assert_equal 16, key.key.length
    assert_match(/\A[0-9A-F ]+\z/, key.to_s)

    assert_equal 8, HSMR::Key.new(nil, HSMR::SINGLE).length
    assert_equal 24, HSMR::Key.new(nil, HSMR::TRIPLE).length

    refute_equal HSMR::Key.new.to_s, HSMR::Key.new.to_s
  end

  def test_key_does_not_mutate_the_component_array_it_is_given
    components = [HSMR::Component.new("0123456789ABCDEF"), HSMR::Component.new("FEDCBA9876543210")]
    HSMR::Key.new(components)
    assert_equal 2, components.length
  end

  # Vectors below are from the HSM notes in doc/ -- values produced by a real
  # HSM, not by this library.

  def test_PIN_block_encryption_matches_known_HSM_values
    # doc/encryption.txt
    vectors = [
      %W{ 0123456789ABCDEFFEDCBA9876543210 1234000000000000 D4718F4CA902C2A3 },
      %W{ 0123456789ABCDEFFEDCBA9876543210 8881000000000000 9EE1F2989B005F6A },
      %W{ 0123456789ABCDEFFEDCBA9876543210 9254000000000000 30D7E71ADB09B2F6 },
      %W{ 0123456789ABCDEFFEDCBA9876543210 1927000000000000 F7DE2452CC64FC6D },
      %W{ 0123456789ABCDEFFEDCBA9876543210 8363000000000000 A947B12F1E7F345A },
      %W{ BA942A01EC6EABCD107346CB61F4F4FE 1234000000000000 5DFA5CE9EDCF20D9 },
      %W{ BA942A01EC6EABCD107346CB61F4F4FE 8881000000000000 9E22FC9F1539BF54 },
      %W{ BA942A01EC6EABCD107346CB61F4F4FE 9254000000000000 B30A6DE41326C0FE },
      %W{ BA942A01EC6EABCD107346CB61F4F4FE 1927000000000000 E905C2F4E94638B7 },
      %W{ BA942A01EC6EABCD107346CB61F4F4FE 8363000000000000 FE18700A5357D343 },
      %W{ 4A3DB34F255EA743ECDA19D0945ECB31 1234000000000000 77B3EAD1F9CEAB4E },
      %W{ 4A3DB34F255EA743ECDA19D0945ECB31 8881000000000000 BF0E37A91DA9D878 },
      %W{ 4A3DB34F255EA743ECDA19D0945ECB31 9254000000000000 43A8D24E4DAC0D5C },
      %W{ 4A3DB34F255EA743ECDA19D0945ECB31 1927000000000000 4D367C663AB681F1 },
      %W{ 4A3DB34F255EA743ECDA19D0945ECB31 8363000000000000 33D63EC052648F5B },
    ]

    vectors.each do |hex_key, pinblock, expected|
      key = HSMR::Key.new(hex_key)
      assert_equal expected, HSMR::encrypt_pin(key, pinblock)
      assert_equal pinblock, HSMR::decrypt_pin(key, expected)
    end
  end

  def test_setting_odd_parity_fixes_every_byte
    # doc/parity.txt. The third pair starts with an odd byte but has even bytes
    # later on -- odd_parity? used to check only the first byte and leave it be.
    [%W{ 41A2AC14A90C583741A2AC14A90C5837 40A2AD15A80D583740A2AD15A80D5837 },
     %W{ F2AEDAE3FEE90DC2921F01341F54D37F F2AEDAE3FEE90DC2921F01341F54D37F },
     %W{ 80EFEC4895855B06B4015041C3F9F61F 80EFEC4994855B07B5015140C2F8F71F },
     %W{ 4D3DE6AA837AA60A413DDD6CBCB12C82 4C3DE6AB837AA70B403DDC6DBCB02C83 },
     %W{ 1E74C6914F41E5EFD9969A0B134EF819 1F75C7914F40E5EFD9979B0B134FF819 }].each do |input, expected|
      assert_equal expected, HSMR::Key.new(input).set_odd_parity.to_s.gsub(" ", "")
      assert HSMR::Key.new(expected).odd_parity?
    end
  end

  def test_odd_parity_checks_every_byte_not_just_the_first
    # First byte 0x80 is odd, but later bytes are not.
    refute HSMR::Key.new("80EFEC4895855B06B4015041C3F9F61F").odd_parity?
    assert_equal "even", HSMR::Key.new("80EFEC4895855B06B4015041C3F9F61F").parity
    assert_equal "odd",  HSMR::Key.new("0123456789ABCDEF").parity
  end

  def test_double_length_key_KCV_values_from_HSM_notes
    # doc/test values.txt and doc/HSM Stuff/me test send key.txt
    [%W{ 23232323232323234545454545454545 3A42D7 },
     %W{ 45454545454545452323232323232323 AC5700 },
     %W{ 67676767676767676767676767676767 B0B563 },
     %W{ B5199D109D46E6914AB96D6E7F7CDAA8 F0916F },
     %W{ AE9232A20276E0D03B16EC4C2C01CBC7 FB599F },
     %W{ 25F491A467FDF7CEB3B0E6135BA78C0D 098FA4 }].each do |hex_key, kcv|
      assert_equal kcv, HSMR::Key.new(hex_key).kcv
    end
  end

  def test_PVV_generation_across_PVK_indexes
    # doc/test values.txt -- the other PVV test only ever uses PVKI 2.
    pvk = HSMR::Key.new("0123456789ABCDEF" * 2)

    assert_equal "8056", HSMR::pvv(pvk, "1234123412341234", "1", "1234")
    assert_equal "2485", HSMR::pvv(pvk, "1234123412341234", "2", "1234")
    assert_equal "6495", HSMR::pvv(pvk, "1234123412341234", "1", "4592")
  end

  def test_des_rejects_keys_of_the_wrong_length
    assert_raises(ArgumentError) { HSMR.des("short", :encrypt) }
  end
  def test_README_examples_still_hold
    # Every value shown in README.md, so the docs cannot drift from the code.
    key = HSMR::Key.new("4CA2161637D0133E5E151AEA45DA2A12")

    assert_equal "4CA2 1616 37D0 133E 5E15 1AEA 45DA 2A12", key.to_s
    assert_equal "7B0898", key.kcv
    assert_equal "even", key.parity
    refute key.odd_parity?
    assert_equal 8, HSMR::Key.new(nil, HSMR::SINGLE).length

    # Parity bits sit outside the DES key schedule, so the kcv is unchanged
    kcv_before = key.kcv
    assert_equal "4CA2 1616 37D0 133E 5E15 1AEA 45DA 2A13", key.set_odd_parity.to_s
    assert_equal kcv_before, key.kcv

    c1 = HSMR::Component.new("0123456789ABCDEF")
    c2 = HSMR::Component.new("FEDCBA9876543210")
    assert_equal "0123 4567 89AB CDEF", c1.to_s
    assert_equal "D5D44F", c1.kcv
    combined = HSMR::Key.new([c1, c2])
    assert_equal "FFFF FFFF FFFF FFFF", combined.to_s
    assert_equal "CAAAAF", combined.kcv

    zmk = HSMR::Key.new("0123456789ABCDEFFEDCBA9876543210")
    block = HSMR.encrypt_pin(zmk, "041274FFFFFFFFFF")
    assert_equal "CFB709CC37D9262A", block
    assert_equal "041274FFFFFFFFFF", HSMR.decrypt_pin(zmk, block)

    pgk = HSMR::Key.new("3737373737373737")
    assert_equal "4412", HSMR.ibm3624(pgk, "5560501200002101", 4, "0123456789012345").join

    pvk = HSMR::Key.new("4CA2161637D0133E5E151AEA45DA2A12")
    assert_equal "0798", HSMR.pvv(pvk, "5999997890123412", "1", "1234")

    cvk_a = HSMR::Key.new("1111111111111111")
    cvk_b = HSMR::Key.new("1111111111111111")
    assert_equal "317", HSMR.cvv(cvk_a, cvk_b, "5560501200002101", "1010", "0")
    assert_equal "134", HSMR.cvv(cvk_a, cvk_b, "5560501200002101", "1010", "101")
  end
end
