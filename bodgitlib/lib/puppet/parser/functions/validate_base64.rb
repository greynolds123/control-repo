#
# validate_base64.rb
#

require 'base64'

module Puppet::Parser::Functions
  newfunction(:validate_base64, :doc => <<-EOS
    Validate that all passed values are base64-encoded strings. Abort
    catalog compilation if any value fails this check.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, 'validate_base64(): Wrong number of ' +
      "arguments given (#{arguments.size} for 1)") if arguments.size != 1

    item = arguments[0]

    unless item.is_a?(Array)
      item = [item]
    end

    if item.size == 0
      raise(Puppet::ParseError, 'validate_base64(): Requires an array ' +
        'with at least 1 element')
    end

    item.each do |i|
      unless i.is_a?(String)
        raise(Puppet::ParseError, 'validate_base64(): Requires either an ' +
          'array or string to work with')
      end

      encoded = i.gsub(/\s+/, '') # Remove any whitespace or linebreaks
      decoded = Base64.decode64(encoded)
      recoded = Base64.encode64(decoded).gsub(/\s+/, '') # encode64 will add linebreaks
      unless encoded.eql?(recoded)
        raise(Puppet::ParseError, "#{i.inspect} is not a Base64-encoded string")
      end
    end
  end
end
