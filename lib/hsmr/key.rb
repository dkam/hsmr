module HSMR
  class Key
    include HSMR

    attr_reader :key
    attr_reader :length

    def initialize(init=nil, length=DOUBLE)
      raise ArgumentError, "at least one component is required" if init.is_a?(Array) && init.empty?

      # A single element array is just that element
      init = init.first if init.is_a?(Array) && init.length == 1

      case init
      when Array
        components = init.collect {|c| c.is_a?(HSMR::Component) ? c : HSMR::Component.new(c) }
        @key = HSMR::xor(components.pop, *components).key
      when Component
        @key = init.component
      when String
        @key = from_hex(init)
      when nil
        @key = from_hex(generate(length))
      else
        raise TypeError, "expected a String, Array, Component or nil, got #{init.class}"
      end

      @length = @key.length
    end

    private

    def from_hex(hex)
      hex = hex.gsub(/ /,'')
      hex.unpack('a2'*(hex.length/2)).map{|x| x.hex}.pack('c'*(hex.length/2))
    end
  end
end
