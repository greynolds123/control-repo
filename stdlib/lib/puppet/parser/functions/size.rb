#
# size.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:size, :type => :rvalue, :doc => <<-EOS
Returns the number of elements in a string, an array or a hash
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "size(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    item = arguments[0]

=======
module Puppet::Parser::Functions
  newfunction(:size, :type => :rvalue, :doc => <<-DOC
    Returns the number of elements in a string, an array or a hash
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "size(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    item = arguments[0]

    function_deprecation([:size, 'This method is going to be deprecated, please use the stdlib length function.'])

>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    if item.is_a?(String)

      begin
        #
        # Check whether your item is a numeric value or not ...
        # This will take care about positive and/or negative numbers
        # for both integer and floating-point values ...
        #
        # Please note that Puppet has no notion of hexadecimal
        # nor octal numbers for its DSL at this point in time ...
        #
        Float(item)

<<<<<<< HEAD
        raise(Puppet::ParseError, 'size(): Requires either ' +
          'string, array or hash to work with')

=======
        raise(Puppet::ParseError, 'size(): Requires either string, array or hash to work with')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      rescue ArgumentError
        result = item.size
      end

    elsif item.is_a?(Array) || item.is_a?(Hash)
      result = item.size
    else
      raise(Puppet::ParseError, 'size(): Unknown type given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
