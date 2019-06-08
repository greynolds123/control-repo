module PuppetX
  module PuppetLabs
    module NetdevStdlib
      module Property
        class PortRange < Puppet::Property
          validate do |value|
<<<<<<< HEAD
            fail "value #{value.inspect} is invalid, must be 1-65535." unless
=======
            raise "value #{value.inspect} is invalid, must be 1-65535." unless
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
            value.to_i.between?(1, 65_535)
            super(value)
          end
        end
      end
    end
  end
end
