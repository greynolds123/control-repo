# Namespaced upcase function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/upcase.rb

module Puppet::Parser::Functions
  newfunction(:pe_upcase, :type => :rvalue, :doc => <<-EOS
Converts a string or an array of strings to uppercase.

*Examples:*

    pe_upcase("abcd")

Will return:

    ASDF
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "pe_upcase(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'pe_upcase(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.upcase : i }
    else
      result = value.upcase
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
