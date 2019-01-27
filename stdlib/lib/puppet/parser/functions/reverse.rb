#
# reverse.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:reverse, :type => :rvalue, :doc => <<-EOS
Reverses the order of a string or array.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "reverse(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:reverse, :type => :rvalue, :doc => <<-DOC
    Reverses the order of a string or array.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "reverse(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'reverse(): Requires either ' +
        'array or string to work with')
=======
      raise(Puppet::ParseError, 'reverse(): Requires either array or string to work with')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    result = value.reverse

    return result
  end
end

# vim: set ts=2 sw=2 et :
