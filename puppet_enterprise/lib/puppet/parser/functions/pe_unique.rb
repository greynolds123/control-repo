# Name spaced unique function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/unique.rb

module Puppet::Parser::Functions
  newfunction(:pe_unique, :type => :rvalue, :doc => <<-EOS
This function will remove duplicates from strings and arrays.

*Examples:*

    pe_unique("aabbcc")

Will return:

    abc

You can also use this with arrays:

    pe_unique(["a","a","b","b","c","c"])

This returns:

    ["a","b","c"]
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "pe_unique(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'pe_unique(): Requires either ' +
        'array or string to work with')
    end

    result = value.clone

    string = value.is_a?(String) ? true : false

    # We turn any string value into an array to be able to shuffle ...
    result = string ? result.split('') : result
    result = result.uniq # Remove duplicates ...
    result = string ? result.join : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
