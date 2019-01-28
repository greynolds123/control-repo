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
    klass = value.class

    unless [Array, Hash, String].include?(klass)
      raise(Puppet::ParseError, 'pe_empty(): Requires either ' +
        'array, hash or string to work with')
    end

    result = value.empty?

    return result
  end
end

# vim: set ts=2 sw=2 et :
