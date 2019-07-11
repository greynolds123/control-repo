# Namespaced prefix function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/suffix.rb

module Puppet::Parser::Functions
  newfunction(:pe_suffix, :type => :rvalue, :doc => <<-EOS
This function applies a suffix to all elements in an array.

*Examples:*

    pe_suffix(['a','b','c'], 'p')

Will return: ['ap','bp','cp']
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "pe_suffix(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise Puppet::ParseError, "pe_suffix(): expected first argument to be an Array, got #{array.inspect}"
    end

    suffix = arguments[1] if arguments[1]

    if suffix
      unless suffix.is_a? String
        raise Puppet::ParseError, "pe_suffix(): expected second argument to be a String, got #{suffix.inspect}"
      end
    end

    # Turn everything into string same as join would do ...
    result = array.collect do |i|
      i = i.to_s
      suffix ? i + suffix : i
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :


