module HSMR
  class Key
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
        key = (0...(length/4)).collect { rand(16).to_s(16).upcase }.join
        @key = key.unpack('a2'*(key.length/2)).map{|x| x.hex}.pack('c'*(key.length/2))
      end
      @length = @key.length
    end 

    def kcv()
      des = OpenSSL::Cipher::Cipher.new("des-cbc") if @key.length == 8
      des = OpenSSL::Cipher::Cipher.new("des-ede-cbc") if @key.length == 16
      des.encrypt
      des.key=@key
      des.update("\x00"*8).unpack('H*').first[0...6].upcase
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

    def odd_parity?
      # http://csrc.nist.gov/publications/nistpubs/800-67/SP800-67.pdf
      #
      # The eight error detecting bits are set to make the parity of each 8-bit 
      # byte of the key odd. That is, there is an odd number of "1"s in each 8-bit byte.
 
      #3.to_s(2).count('1')
      #@key.unpack("H2").first.to_i(16).to_s(2)

      working=@key.unpack('H2'*(@key.length))
      working.each do |o| 
        freq = o.to_i(16).to_s(2).count('1').to_i
        if( freq%2 == 0)
          #puts "#{o} is #{o.to_i(16).to_s(2).count('1').to_i } - even" 
          return false
        else
          return true
          #puts "#{o} is #{o.to_i(16).to_s(2).count('1').to_i } - odd" 
        end
      end      
    end
    def set_odd_parity
      return true if self.odd_parity? == true
          
      working=@key.unpack('H2'*(@key.length))
      working.each_with_index do |o,i|
        freq = o.to_i(16).to_s(2).count('1').to_i
        if( freq%2 == 0)
          c1 = o[0].chr
          c2 = case o[1].chr
            when "0" then "1"
            when "1" then "0"
            when "2" then "3"
            when "3" then "2"
            when "4" then "5"
            when "5" then "4"
            when "6" then "7"
            when "7" then "6"
            when "8" then "9"
            when "9" then "8"
            when "a" then "b"
            when "b" then "a"
            when "c" then "d"
            when "d" then "c"
            when "e" then "f"
            when "f" then "e"
          end
          working[i]="#{c1}#{c2}"
        end
      end
      @key = working.join.unpack('a2'*(working.length)).map{|x| x.hex}.pack('c'*(working.length))
    end

    def to_s
      @key.unpack('H4 '* (@length/2) ).join(" ").upcase
    end
  end
end
