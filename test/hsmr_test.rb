require 'test_helper'

class TestHSMR < Test::Unit::TestCase
  test "generate a component " do
	  component_1 = HSMR::Component.new(nil, HSMR::SINGLE)
	  component_2 = HSMR::Component.new(nil, HSMR::DOUBLE)
	  component_3 = HSMR::Component.new(nil, HSMR::TRIPLE)	  	

	  assert_equal 8,  component_1.length
    assert_equal 16, component_2.length
    assert_equal 24, component_3.length
  end

  test "caclulation of single length component KCV values" do 
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

  test "should calculate double length key KCV values" do 
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

  test "should detect odd_parity in a key" do
    odd_key  = HSMR::Key.new("41A2AC14A90C583741A2AC14A90C5837")
    assert_false odd_key.odd_parity?
  end
  
  test "should set double length key parity to odd" do 
    odd_key  = HSMR::Key.new("41A2AC14A90C583741A2AC14A90C5837")

    odd_key.set_odd_parity
    
    even_key = HSMR::Key.new("40A2AD15A80D583740A2AD15A80D5837")
    
    assert_equal odd_key.key, even_key.key
  end
  
  test "should detect odd_parity in a component" do
    odd_component  = HSMR::Component.new("41A2AC14A90C583741A2AC14A90C5837")
    assert_false odd_component.odd_parity?
  end
  
  test "should set double length component parity to odd" do 
    odd_component  = HSMR::Component.new("41A2AC14A90C583741A2AC14A90C5837")
    
    odd_component.set_odd_parity
    
    even_component = HSMR::Component.new("40A2AD15A80D583740A2AD15A80D5837")
        
    assert_equal odd_component.component, even_component.component
  end

  test "Converting string to ascii works" do
    key_string = "E57A DF5B CEA7 F42A DFD9 E554 07A2 F891"
    key = HSMR::Key.new(key_string)

    assert_equal key.to_s, key_string 

    key_string = "E57A DF5B CEA7 F42A DFD9 E554 07A2 F891"
    comp = HSMR::Component.new(key_string)

    assert_equal comp.to_s, key_string 
  end

  test "tests CVC / CVC2 calculations" do
    # Component 1      Component 2      PAN              EXP  SCode  CVC
    # 1234567890ABCDEF FEDCBA1234567890 5656565656565656 1010 ___ 922
    # 1234567890ABCDEF FEDCBA1234567890 5656565656565656 1010 000 922
    # 1234567890ABCDEF FEDCBA1234567890 5683739237489383838 1010 000 367
    # 1234567890ABCDEF FEDCBA1234567890 568367393472639 1010 000 067
    # 1234567890ABCDEF FEDCBA1234567890 5683673934726394 1010 000 409
    # 1234567890ABCDEF FEDCBA1234567890 5683673934726394 1010 050 CVV248 or CVC409
    # 1234567890ABCDEF FEDCBA1234567890 5683673934726394 1010 101 CVV501 or CVC409
    # 1234567890ABCDEF FEDCBA1234567890 5683673934726394 1010 102 CVV206 or CVC409

    kl = "0123456789ABCDEF" 
    kr = "FEDCBA1234567890"

    HSMR.cvv(kl, kr, "4509494222049051", "0907", "1010")
  end

end
