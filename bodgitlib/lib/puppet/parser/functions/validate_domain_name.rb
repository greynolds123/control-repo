#
# validate_domain_name.rb
#

module Puppet::Parser::Functions
  newfunction(:validate_domain_name, :doc => <<-EOS
    Validate that all passed values are valid domain names. Abort
    catalog compilation if any value fails this check.
    EOS
  ) do |arguments|

    rescuable_exceptions = [ArgumentError]

    raise Puppet::ParseError, 'validate_domain_name(): Wrong number of ' +
      "arguments given (#{arguments.size} for 1)" if arguments.size != 1

    item = arguments[0]

    unless item.is_a?(Array)
      item = [item]
    end

    if item.size == 0
      raise Puppet::ParseError, 'validate_domain_name(): Requires an array ' +
        'with at least 1 element'
    end

    item.each do |i|
      unless i.is_a?(String)
        raise Puppet::ParseError, 'validate_domain_name(): Requires either ' +
          'an array or string to work with'
      end

      begin
        raise Puppet::ParseError, "#{i.inspect} is not a valid domain name" unless function_is_domain_name([i])
      rescue *rescuable_exceptions
        raise Puppet::ParseError, "#{i.inspect} is not a valid domain name"
      end
    end
  end
end
