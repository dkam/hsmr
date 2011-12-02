module HSMR
  class Component
    include HSMR
    attr_reader :key
    attr_reader :length

    def component
      @key
    end
    
    def initialize(key=nil, length=DOUBLE)
      ## Should check for odd parity
      if key.nil?
        key = generate(length)
      else
        key=key.gsub(/ /,'')
        #raise TypeError, "Component argument expected" unless other.is_a? Component
      end
      @key = key.unpack('a2'*(key.length/2)).map{|x| x.hex}.pack('c'*(key.length/2))
      @length = @key.length
      @key = @key
    end
    
#    def xor(other)
#      other = Component.new(other) unless other.is_a? Component
#      raise TypeError, "Component argument expected" unless other.is_a? Component
#      
#      @a = @key.unpack('C2'*(@key.length/2))
#      @b = other.component.unpack('C2'*(other.component.length/2))
#
#      #result = @a.zip(@b).map {|x,y| x^y}.map {|z| z.to_s(16) }.join.upcase
#      result = @a.zip(@b).map {|x,y| x^y}.map {|z| z.to_s(16) }.map {|c| c.length == 1 ? '0'+c : c }.join.upcase
#
#      Key.new(result)
#    end

  end
end
