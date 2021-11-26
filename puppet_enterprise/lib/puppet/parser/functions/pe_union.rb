# Namespaced union function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/union.rb

module Puppet::Parser::Functions
  newfunction(:pe_union, :type => :rvalue, :doc => <<-EOS
This function returns a union of two arrays.

*Examples:*

    pe_union(["a","b","c"],["b","c","d"])

Would return: ["a","b","c","d"]
    EOS
  ) do |arguments|

    # Two arguments are required
    raise(Puppet::ParseError, "pe_union(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size != 2

    first = arguments[0]
    second = arguments[1]

    unless first.is_a?(Array) && second.is_a?(Array)
      raise(Puppet::ParseError, 'pe_union(): Requires 2 arrays')
    end

    result = first | second

    return result
  end
end

# vim: set ts=2 sw=2 et :
