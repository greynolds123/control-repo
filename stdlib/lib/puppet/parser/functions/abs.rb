#
# abs.rb
#
module Puppet::Parser::Functions
  newfunction(:abs, :type => :rvalue, :doc => <<-DOC
    Returns the absolute value of a number, for example -34.56 becomes
    34.56. Takes a single integer and float value as an argument.
<<<<<<< HEAD
=======

    Note: from Puppet 6.0.0, the compatible function with the same name in Puppet core
    will be used instead of this function.
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "abs(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    # Numbers in Puppet are often string-encoded which is troublesome ...
    if value.is_a?(String)
      if value =~ %r{^-?(?:\d+)(?:\.\d+){1}$}
        value = value.to_f
      elsif value =~ %r{^-?\d+$}
        value = value.to_i
      else
        raise(Puppet::ParseError, 'abs(): Requires float or integer to work with')
      end
    end

    # We have numeric value to handle ...
    result = value.abs

    return result
  end
end

# vim: set ts=2 sw=2 et :
