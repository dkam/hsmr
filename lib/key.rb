module HSMR
  class Key
    include HSMR

    attr_reader :key
    attr_reader :length
    attr_reader :parity

    def initialize(init=nil, length=DOUBLE)
      return nil if (init.is_a? Array ) && (init.length == 0) 
      
      init = init.first if (init.is_a? Array) && (init.length == 1)
      
      if init.is_a? Array
        init.collect! {|c| ( (c.is_a? HSMR::Component) ? c : HSMR::Component.new(c) ) }

        raise TypeError, "Component argument expected" unless init.first.is_a? Component
      
        @key=HSMR::xor(init.pop, init).key
    
      elsif init.is_a? Component
        @key = init.component
      elsif init.is_a? String
        key=init.gsub(/ /,'')
        @key = key.unpack('a2'*(key.length/2)).map{|x| x.hex}.pack('c'*(key.length/2))
      elsif key.nil?
        key = generate(length)
        @key = key.unpack('a2'*(key.length/2)).map{|x| x.hex}.pack('c'*(key.length/2))
      end
      @length = @key.length
    end 

    def xor(other)
      other=Component.new(other) if other.is_a? String
      other=Component.new(other.key) if other.is_a? Key
      
      raise TypeError, "Component argument expected" unless other.is_a? Component
      
      @a = @key.unpack('C2'*(@key.length/2))
      @b = other.component.unpack('C2'*(@key.length/2))
      
      resultant = Key.new( @a.zip(@b).map {|x,y| x^y}.map {|z| z.to_s(16) }.join.upcase )
    end
    
    def xor!(_key)
      @key = xor(_key).key
    end

  end
end
