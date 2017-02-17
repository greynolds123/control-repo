require 'securerandom'

module Puppet::Parser::Functions
  newfunction(:cookie_secret_key, :type => :rvalue) do |args|
    string_length = if args[0]
                      args[0].to_i
                    else
                      16 # default to a 16 character string
                    end

    # SecureRandom#hex returns a string with a length of twice the argument, so divide by two to get the string length
    # that the user is expecting
    SecureRandom.hex(string_length / 2)
  end
end
