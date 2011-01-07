require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Generate Component" do
	it "should generate a component" do
	  component_1 = HSMR::Component.new(nil, HSMR::SINGLE)
	  component_2 = HSMR::Component.new(nil, HSMR::DOUBLE)
	  component_3 = HSMR::Component.new(nil, HSMR::TRIPLE)	  	

	  component_1.length.should == 8
	  component_2.length.should == 16
	  component_3.length.should == 24	  	    
  end
end

describe "Calculate component KCV" do
  
  it "should calculate single length component KCV values" do 
    component_1 = HSMR::Component.new("6DBF C180 4A01 5BAD")
    component_1.kcv.should == "029E60"

    component_2 = HSMR::Component.new("5D80 0497 B319 8591")
    component_2.kcv.should == "3B86C3"

    component_3 = HSMR::Component.new("B0C7 7CDC 7354 97C7")
    component_3.kcv.should == "7A77BC"

    component_4 = HSMR::Component.new("DAE0 86FE D6EA 0BEA")
    component_4.kcv.should == "2E6191"

    component_5 = HSMR::Component.new("682C 8315 F4BF FBC1")
    component_5.kcv.should == "62B336"

    component_6 = HSMR::Component.new("5715 F289 04BC B62F")
    component_6.kcv.should == "3CBA88"

    component_7 = HSMR::Component.new("D0C4 29AE C4A8 02B5")
    component_7.kcv.should == "33AF02"

    component_8 = HSMR::Component.new("7049 D0F7 4A97 15B6")
    component_8.kcv.should == "AC1399"

    component_9 = HSMR::Component.new("BC91 D698 157A A4E5")
    component_9.kcv.should == "295491"

    component_10 = HSMR::Component.new("64AB 8568 7A0E 322F")
    component_10.kcv.should == "D9F7B3"
  end

  it "should calculate double length component KCV values" do 
    component_1 = HSMR::Component.new("ADE3 9B38 0DBC DF38 AE02 AECE 64B3 4373")
    component_1.kcv.should == "3002D5"

    component_2 = HSMR::Component.new("B64A EF86 460D DF5B 57B3 D53D AD37 52A1")
    component_2.kcv.should == "1F7C07"

    component_3 = HSMR::Component.new("5B89 6E29 76EC 9745 15B5 238C 8CFE 3D23")
    component_3.kcv.should == "DE78F2"

    component_4 = HSMR::Component.new("5E61 CB20 D540 1FC7 58EC CDC8 B558 E9B9")
    component_4.kcv.should == "FED957"

    component_5 = HSMR::Component.new("23DF CEB9 BF94 ADA8 91E9 580B 8C8F 5BEF")
    component_5.kcv.should == "902085"

    component_6 = HSMR::Component.new("DFEF 61C8 2037 3DA4 CE9B 92CD 89E9 B334")
    component_6.kcv.should == "E45EB7"

    component_7 = HSMR::Component.new("6746 9E4C FE83 F831 F23E 9D9E 9D9E 9DB3")
    component_7.kcv.should == "813B7B"

    component_8 = HSMR::Component.new("23E5 496E DF94 0BD5 9734 B07A BF26 B9E6")
    component_8.kcv.should == "E7C48F"

    component_9 = HSMR::Component.new("974F 26BC CB2A ECD5 434F 1CDC 64DF A275")
    component_9.kcv.should == "E27250"

    component_10 = HSMR::Component.new("E57A DF5B CEA7 F42A DFD9 E554 07A2 F891")
    component_10.kcv.should == "50E3F8"
  end
end

describe "Calculate key KCV" do
  
  it "should calculate single length key KCV values" do 
    key_1 = HSMR::Key.new("6DBF C180 4A01 5BAD")
    key_1.kcv.should == "029E60"

    key_2 = HSMR::Key.new("5D80 0497 B319 8591")
    key_2.kcv.should == "3B86C3"

    key_3 = HSMR::Key.new("B0C7 7CDC 7354 97C7")
    key_3.kcv.should == "7A77BC"

    key_4 = HSMR::Key.new("DAE0 86FE D6EA 0BEA")
    key_4.kcv.should == "2E6191"

    key_5 = HSMR::Key.new("682C 8315 F4BF FBC1")
    key_5.kcv.should == "62B336"

    key_6 = HSMR::Key.new("5715 F289 04BC B62F")
    key_6.kcv.should == "3CBA88"

    key_7 = HSMR::Key.new("D0C4 29AE C4A8 02B5")
    key_7.kcv.should == "33AF02"

    key_8 = HSMR::Key.new("7049 D0F7 4A97 15B6")
    key_8.kcv.should == "AC1399"

    key_9 = HSMR::Key.new("BC91 D698 157A A4E5")
    key_9.kcv.should == "295491"

    key_10 = HSMR::Key.new("64AB 8568 7A0E 322F")
    key_10.kcv.should == "D9F7B3"
  end
  it "should calculate double length key KCV values" do 
    key_1 = HSMR::Key.new("ADE3 9B38 0DBC DF38 AE02 AECE 64B3 4373")
    key_1.kcv.should == "3002D5"

    key_2 = HSMR::Key.new("B64A EF86 460D DF5B 57B3 D53D AD37 52A1")
    key_2.kcv.should == "1F7C07"

    key_3 = HSMR::Key.new("5B89 6E29 76EC 9745 15B5 238C 8CFE 3D23")
    key_3.kcv.should == "DE78F2"

    key_4 = HSMR::Key.new("5E61 CB20 D540 1FC7 58EC CDC8 B558 E9B9")
    key_4.kcv.should == "FED957"

    key_5 = HSMR::Key.new("23DF CEB9 BF94 ADA8 91E9 580B 8C8F 5BEF")
    key_5.kcv.should == "902085"

    key_6 = HSMR::Key.new("DFEF 61C8 2037 3DA4 CE9B 92CD 89E9 B334")
    key_6.kcv.should == "E45EB7"

    key_7 = HSMR::Key.new("6746 9E4C FE83 F831 F23E 9D9E 9D9E 9DB3")
    key_7.kcv.should == "813B7B"

    key_8 = HSMR::Key.new("23E5 496E DF94 0BD5 9734 B07A BF26 B9E6")
    key_8.kcv.should == "E7C48F"

    key_9 = HSMR::Key.new("974F 26BC CB2A ECD5 434F 1CDC 64DF A275")
    key_9.kcv.should == "E27250"

    key_10 = HSMR::Key.new("E57A DF5B CEA7 F42A DFD9 E554 07A2 F891")
    key_10.kcv.should == "50E3F8"
  end
end

describe "Calculate parity" do
  it "should detect odd_parity in a key" do
    odd_key  = HSMR::Key.new("41A2AC14A90C583741A2AC14A90C5837")
    odd_key.odd_parity?.should == false     
  end
  
  it "should set double length key parity to odd" do 
    odd_key  = HSMR::Key.new("41A2AC14A90C583741A2AC14A90C5837")

    odd_key.set_odd_parity
    
    even_key = HSMR::Key.new("40A2AD15A80D583740A2AD15A80D5837")
    
    odd_key.key.should == even_key.key
    
  end
  
  it "should detect odd_parity in a component" do
    odd_component  = HSMR::Component.new("41A2AC14A90C583741A2AC14A90C5837")
    odd_component.odd_parity?.should == false     
  end
  
  it "should set double length component parity to odd" do 
    odd_component  = HSMR::Component.new("41A2AC14A90C583741A2AC14A90C5837")
    
    odd_component.set_odd_parity
    
    even_component = HSMR::Component.new("40A2AD15A80D583740A2AD15A80D5837")
        
    odd_component.component.should == even_component.component
        
  end
  
end
