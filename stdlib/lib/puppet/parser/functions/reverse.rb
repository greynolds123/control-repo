#
# reverse.rb
#
module Puppet::Parser::Functions
  newfunction(:reverse, :type => :rvalue, :doc => <<-DOC
<<<<<<< HEAD
    Reverses the order of a string or array.

    Note that the same can be done with the reverse_each() function in Puppet.
=======
    @summary
      Reverses the order of a string or array.

    @return
      reversed string or array

    > *Note:* that the same can be done with the reverse_each() function in Puppet.
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
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
