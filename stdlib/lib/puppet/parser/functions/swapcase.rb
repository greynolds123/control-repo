#
#  swapcase.rb
<<<<<<< HEAD
#

module Puppet::Parser::Functions
  newfunction(:swapcase, :type => :rvalue, :doc => <<-EOS
This function will swap the existing case of a string.

*Examples:*

    swapcase("aBcD")

Would result in: "AbCd"
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "swapcase(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
module Puppet::Parser::Functions
  newfunction(:swapcase, :type => :rvalue, :doc => <<-DOC
    This function will swap the existing case of a string.

    *Examples:*

        swapcase("aBcD")

    Would result in: "AbCd"
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "swapcase(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'swapcase(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.swapcase : i }
    else
      result = value.swapcase
    end
=======
      raise(Puppet::ParseError, 'swapcase(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
               value.map { |i| i.is_a?(String) ? i.swapcase : i }
             else
               value.swapcase
             end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    return result
  end
end

# vim: set ts=2 sw=2 et :
