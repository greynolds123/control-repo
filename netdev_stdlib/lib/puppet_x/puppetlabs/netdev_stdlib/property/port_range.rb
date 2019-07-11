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
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
            value.to_i.between?(1, 65_535)
            super(value)
          end
        end
      end
    end
  end
end
