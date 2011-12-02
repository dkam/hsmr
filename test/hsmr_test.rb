require 'test_helper'

class TestHSMR < Test::Unit::TestCase

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
      assert_equal true,  HSMR::Key.new(pair[0]).odd_parity?
      assert_equal false, HSMR::Key.new(pair[1]).odd_parity?

      assert_equal true,  HSMR::Component.new(pair[0]).odd_parity?
      assert_equal false, HSMR::Component.new(pair[1]).odd_parity?
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
    cases = []
              #  Component 1      Component 2      PAN                 EXP  SCode  CVC
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 5656565656565656    1010 ___   922 }
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 5656565656565656    1010 000   922 }
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 5683739237489383838 1010 000   367 }
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 568367393472639     1010 000   067 }
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 5683673934726394    1010 000   409 }
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 5683673934726394    1010 050   CVV248 or CVC409 }
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 5683673934726394    1010 101   CVV501 or CVC409 }
    cases << %W{ 1234567890ABCDEF FEDCBA1234567890 5683673934726394    1010 102   CVV206 or CVC409 }

    kl = "0123456789ABCDEF" 
    kr = "FEDCBA1234567890"

    #HSMR.cvv(kl, kr, "4509494222049051", "0907", "1010")
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
end
