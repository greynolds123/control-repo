#
# abs.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:abs, :type => :rvalue, :doc => <<-EOS
    Returns the absolute value of a number, for example -34.56 becomes
    34.56. Takes a single integer and float value as an argument.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "abs(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:abs, :type => :rvalue, :doc => <<-DOC
    Returns the absolute value of a number, for example -34.56 becomes
    34.56. Takes a single integer and float value as an argument.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "abs(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    value = arguments[0]

    # Numbers in Puppet are often string-encoded which is troublesome ...
    if value.is_a?(String)
<<<<<<< HEAD
      if value.match(/^-?(?:\d+)(?:\.\d+){1}$/)
        value = value.to_f
      elsif value.match(/^-?\d+$/)
        value = value.to_i
      else
        raise(Puppet::ParseError, 'abs(): Requires float or ' +
          'integer to work with')
=======
      if value =~ %r{^-?(?:\d+)(?:\.\d+){1}$}
        value = value.to_f
      elsif value =~ %r{^-?\d+$}
        value = value.to_i
      else
        raise(Puppet::ParseError, 'abs(): Requires float or integer to work with')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end

    # We have numeric value to handle ...
    result = value.abs

    return result
  end
end

# vim: set ts=2 sw=2 et :
