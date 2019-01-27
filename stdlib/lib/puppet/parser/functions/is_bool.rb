#
# is_bool.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:is_bool, :type => :rvalue, :doc => <<-EOS
Returns true if the variable passed to this function is a boolean.
    EOS
  ) do |arguments|

    function_deprecation([:is_bool, 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Bool. There is further documentation for validate_legacy function in the README.'])

    raise(Puppet::ParseError, "is_bool(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1
=======
module Puppet::Parser::Functions
  newfunction(:is_bool, :type => :rvalue, :doc => <<-DOC
    Returns true if the variable passed to this function is a boolean.
    DOC
             ) do |arguments|

    function_deprecation([:is_bool, 'This method is deprecated, please use the stdlib validate_legacy function,
                          with Stdlib::Compat::Bool. There is further documentation for validate_legacy function in the README.'])

    raise(Puppet::ParseError, "is_bool(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    type = arguments[0]

    result = type.is_a?(TrueClass) || type.is_a?(FalseClass)

    return result
  end
end
