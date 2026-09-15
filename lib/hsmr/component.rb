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
      elsif key.is_a? String
        key = key.gsub(/ /,'')
      else
        raise TypeError, "expected a String or nil, got #{key.class}"
      end

      @key = key.unpack('a2'*(key.length/2)).map{|x| x.hex}.pack('c'*(key.length/2))
      @length = @key.length
    end
  end
end
