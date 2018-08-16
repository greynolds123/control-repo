#
# bool2num.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:bool2num, :type => :rvalue, :doc => <<-EOS
=======
module Puppet::Parser::Functions
  newfunction(:bool2num, :type => :rvalue, :doc => <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Converts a boolean to a number. Converts the values:
      false, f, 0, n, and no to 0
      true, t, 1, y, and yes to 1
    Requires a single boolean or string as an input.
<<<<<<< HEAD
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "bool2num(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "bool2num(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = function_str2bool([arguments[0]])

    # We have real boolean values as well ...
    result = value ? 1 : 0

    return result
  end
end

# vim: set ts=2 sw=2 et :
