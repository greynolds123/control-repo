#
# validate_ipv4_address_array.rb
#

module Puppet::Parser::Functions
  newfunction(:validate_ipv4_address_array, :doc => <<-EOS
    Validate that all values passed as an array are all valid IPv4 addresses.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, 'validate_ipv4_address_array(): Wrong number ' +
      "of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    item = arguments[0]

    unless item.is_a?(Array)
      raise(Puppet::ParseError, 'validate_ipv4_address_array(): Requires an ' +
        'array to work with')
    end

    if item.size == 0
      raise(Puppet::ParseError, 'validate_ipv4_address_array(): Requires an ' +
        'array with at least 1 element')
    end

    function_validate_ipv4_address(item.flatten)
  end
end
