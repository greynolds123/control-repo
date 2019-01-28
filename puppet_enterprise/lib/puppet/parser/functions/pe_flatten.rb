# Namespaced flatten function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/flatten.rb

module Puppet::Parser::Functions
  newfunction(:pe_flatten, :type => :rvalue, :doc => <<-EOS
This function flattens any deeply nested arrays and returns a single flat array
as a result.

*Examples:*

    pe_flatten(['a', ['b', ['c']]])

Would return: ['a','b','c']
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "pe_flatten(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'pe_flatten(): Requires array to work with')
    end

    result = array.flatten

    return result
  end
end

# vim: set ts=2 sw=2 et :
