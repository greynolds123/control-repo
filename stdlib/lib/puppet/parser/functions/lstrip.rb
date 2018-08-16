#
#  lstrip.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:lstrip, :type => :rvalue, :doc => <<-EOS
Strips leading spaces to the left of a string.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "lstrip(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:lstrip, :type => :rvalue, :doc => <<-DOC
    Strips leading spaces to the left of a string.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "lstrip(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'lstrip(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.lstrip : i }
    else
      result = value.lstrip
    end
=======
      raise(Puppet::ParseError, 'lstrip(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
               value.map { |i| i.is_a?(String) ? i.lstrip : i }
             else
               value.lstrip
             end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    return result
  end
end

# vim: set ts=2 sw=2 et :
