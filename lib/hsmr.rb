require 'openssl'

module HSMR
  VERSION = '0.0.1'
  
  # Key Lengths
  SINGLE=64
  DOUBLE=128
  TRIPLE=192

  def self.encrypt_pin(key, pin)
    @pin = pin.unpack('a2'*(pin.length/2)).map{|x| x.hex}.pack('c'*(pin.length/2))
    des = OpenSSL::Cipher::Cipher.new("des-ede")
    des.encrypt
    des.key=key.key
    return des.update(@pin).unpack('H*').first.upcase
  end
  
  def self.decrypt_pin(key, pinblock)
    @pinblock = pinblock.unpack('a2'*(pinblock.length/2)).map{|x| x.hex}.pack('c'*(pinblock.length/2))
    des = OpenSSL::Cipher::Cipher.new("des-ede")
    des.decrypt
    des.padding=0
    des.key=key.key
    result = des.update(@pinblock)
    result << des.final
    result.unpack('H*').first.upcase
  end
  
  def self.ibm3624(key, account, plength=4, dtable="0123456789012345" )
    
    validation_data = account.unpack('a2'*(account.length/2)).map{|x| x.hex}.pack('c'*(account.length/2))

    #des = OpenSSL::Cipher::Cipher.new("des-ede-cbc")
    des = OpenSSL::Cipher::Cipher.new("des-cbc")
    des.encrypt
    des.key=key.key
    return HSMR::decimalise(des.update(validation_data).unpack('H*').first, :ibm, dtable)[0...plength]
    
  end
  
  def self.decimalise(value, method=:visa, dtable="0123456789012345" )

    result = []
    if method == :ibm  
      ##
      # The IBM method
      ##
      value.each_char do |c| 
        result << dtable[c.to_i(16),1].to_i
      end
      
    elsif method == :visa
      
      value.each_char do |c|
        result << c.to_i if numeric?(c)
      end
    
      value.upcase.each_char do |c|
        result << dtable[c.to_i(16),1].to_i unless numeric?(c)
      end
      
    end
    
    return result
  end
    
  def self.pvv(key, account, pvki, pin)
    tsp = account.to_s[4,11] + pvki.to_s + pin.to_s
    @tsp = tsp.unpack('a2'*(tsp.length/2)).map{|x| x.hex}.pack('c'*(tsp.length/2))
    des = OpenSSL::Cipher::Cipher.new("des-ede")
    des.encrypt
    des.key=key.key
    result = des.update(@tsp).unpack('H*').first.upcase
    decimalise(result, :visa)[0..3].join
  end
  
  def self.xor(component1, *rest)
    return if rest.length == 0
    
    component1 = Component.new(component1) unless component1.is_a? Component
    raise TypeError, "Component argument expected" unless component1.is_a? Component
    
    #@components=[]
    #rest.each {|c| components << ((c.is_a? HSMR::Component) ? c : HSMR::Component.new(c) ) }
    #components.each {|c| raise TypeError, "Component argument expected" unless c.is_a? Component }
    #resultant = component1.xor(components.pop)
    #components.each {|c| resultant.xor!(c) }

    rest.collect! {|c| ( (c.is_a? HSMR::Component) ? c : HSMR::Component.new(c) ) }
    rest.each {|c| raise TypeError, "Component argument expected" unless c.is_a? HSMR::Component }
    resultant = component1.xor(rest.pop)
    rest.each {|c| resultant.xor!(c) }

    return(resultant)
  end
  
  def self.numeric?(object)
    ## Method to determine if an object is a numeric type.
    true if Float(object) rescue false
  end
end


class String
  def xor(other)
    if other.empty?
      self
    else
      a1        = self.unpack("c*")
      a2        = other.unpack("c*")
      a2 *= 2   while a2.length < a1.length
      a1.zip(a2).collect{|c1,c2| c1^c2}.pack("c*")
    end
  end
end
