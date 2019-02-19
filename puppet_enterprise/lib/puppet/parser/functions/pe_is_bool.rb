# Namespaced is_bool function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/is_bool.rb

module Puppet::Parser::Functions
  newfunction(:pe_is_bool, :type => :rvalue, :doc => <<-EOS
Returns true if the variable passed to this function is a boolean.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "pe_is_bool(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    type = arguments[0]

    result = type.is_a?(TrueClass) || type.is_a?(FalseClass)

    return result
  end
end

# vim: set ts=2 sw=2 et :
