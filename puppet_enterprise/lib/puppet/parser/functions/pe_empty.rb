# Namespaced empty function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/empty.rb

module Puppet::Parser::Functions
  newfunction(:pe_empty, :type => :rvalue, :doc => <<-EOS
Returns true if the variable is empty.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "pe_empty(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(Hash) || value.is_a?(String) || value.is_a?(Numeric)
      raise(Puppet::ParseError, 'pe_empty(): Requires either ' +
        'array, hash, string or integer to work with')
    end

    if value.is_a?(Numeric)
      return false
    else
      result = value.empty?

      return result
    end
  end
end

# vim: set ts=2 sw=2 et :
