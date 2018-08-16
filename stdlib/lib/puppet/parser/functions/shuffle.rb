#
# shuffle.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:shuffle, :type => :rvalue, :doc => <<-EOS
Randomizes the order of a string or array elements.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "shuffle(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:shuffle, :type => :rvalue, :doc => <<-DOC
    Randomizes the order of a string or array elements.
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "shuffle(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'shuffle(): Requires either ' +
        'array or string to work with')
=======
      raise(Puppet::ParseError, 'shuffle(): Requires either array or string to work with')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    result = value.clone

    string = value.is_a?(String) ? true : false

    # Check whether it makes sense to shuffle ...
    return result if result.size <= 1

    # We turn any string value into an array to be able to shuffle ...
    result = string ? result.split('') : result

    elements = result.size

    # Simple implementation of Fisher–Yates in-place shuffle ...
    elements.times do |i|
      j = rand(elements - i) + i
      result[j], result[i] = result[i], result[j]
    end

    result = string ? result.join : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
