#
#  strip.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:strip, :type => :rvalue, :doc => <<-EOS
This function removes leading and trailing whitespace from a string or from
every string inside an array.

*Examples:*

    strip("    aaa   ")

Would result in: "aaa"
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "strip(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:strip, :type => :rvalue, :doc => <<-DOC
    This function removes leading and trailing whitespace from a string or from
    every string inside an array.

    *Examples:*

        strip("    aaa   ")

    Would result in: "aaa"
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "strip(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'strip(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.strip : i }
    else
      result = value.strip
    end
=======
      raise(Puppet::ParseError, 'strip(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               value.map { |i| i.is_a?(String) ? i.strip : i }
             else
               value.strip
             end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    return result
  end
end

# vim: set ts=2 sw=2 et :
