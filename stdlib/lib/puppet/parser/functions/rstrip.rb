#
#  rstrip.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:rstrip, :type => :rvalue, :doc => <<-EOS
Strips leading spaces to the right of the string.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "rstrip(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:rstrip, :type => :rvalue, :doc => <<-DOC
    Strips leading spaces to the right of the string.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "rstrip(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'rstrip(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      result = value.collect { |i| i.is_a?(String) ? i.rstrip : i }
    else
      result = value.rstrip
    end
=======
      raise(Puppet::ParseError, 'rstrip(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               value.map { |i| i.is_a?(String) ? i.rstrip : i }
             else
               value.rstrip
             end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    return result
  end
end

# vim: set ts=2 sw=2 et :
