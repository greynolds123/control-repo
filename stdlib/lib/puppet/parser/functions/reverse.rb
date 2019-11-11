#
# reverse.rb
#
module Puppet::Parser::Functions
  newfunction(:reverse, :type => :rvalue, :doc => <<-DOC
    Reverses the order of a string or array.
<<<<<<< HEAD
=======

    Note that the same can be done with the reverse_each() function in Puppet.
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "reverse(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'reverse(): Requires either array or string to work with')
    end

    result = value.reverse

    return result
  end
end

# vim: set ts=2 sw=2 et :
