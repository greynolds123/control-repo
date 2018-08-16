#
#  capitalize.rb
<<<<<<< HEAD
#

module Puppet::Parser::Functions
  newfunction(:capitalize, :type => :rvalue, :doc => <<-EOS
    Capitalizes the first letter of a string or array of strings.
    Requires either a single string or an array as an input.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "capitalize(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
module Puppet::Parser::Functions
  newfunction(:capitalize, :type => :rvalue, :doc => <<-DOC
    Capitalizes the first letter of a string or array of strings.
    Requires either a single string or an array as an input.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "capitalize(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'capitalize(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? i.capitalize : i }
    else
      result = value.capitalize
    end
=======
      raise(Puppet::ParseError, 'capitalize(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
               value.map { |i| i.is_a?(String) ? i.capitalize : i }
             else
               value.capitalize
             end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    return result
  end
end
<<<<<<< HEAD

# vim: set ts=2 sw=2 et :
=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
