#
#  pe_strip.rb
#

module Puppet::Parser::Functions
  newfunction(:pe_strip, :type => :rvalue, :doc => <<-EOS
This function removes leading and trailing whitespace from a string or from
every string inside an array.

*Examples:*

    pe_strip("    aaa   ")

Would result in: "aaa"
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "pe_strip(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'pe_strip(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.strip : i }
    else
      result = value.strip
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
