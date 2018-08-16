#
# is_hash.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:is_hash, :type => :rvalue, :doc => <<-EOS
Returns true if the variable passed to this function is a hash.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "is_hash(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1
=======
module Puppet::Parser::Functions
  newfunction(:is_hash, :type => :rvalue, :doc => <<-DOC
    Returns true if the variable passed to this function is a hash.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "is_hash(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    type = arguments[0]

    result = type.is_a?(Hash)

    return result
  end
end

# vim: set ts=2 sw=2 et :
