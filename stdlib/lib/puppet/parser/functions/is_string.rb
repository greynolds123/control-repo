#
# is_string.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:is_string, :type => :rvalue, :doc => <<-EOS
Returns true if the variable passed to this function is a string.
    EOS
  ) do |arguments|

    function_deprecation([:is_string, 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::String. There is further documentation for validate_legacy function in the README.'])

    raise(Puppet::ParseError, "is_string(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:is_string, :type => :rvalue, :doc => <<-DOC
    Returns true if the variable passed to this function is a string.
    DOC
             ) do |arguments|

    function_deprecation([:is_string, 'This method is deprecated, please use the stdlib validate_legacy function,
                          with Stdlib::Compat::String. There is further documentation for validate_legacy function in the README.'])

    raise(Puppet::ParseError, "is_string(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    type = arguments[0]

    # when called through the v4 API shim, undef gets translated to nil
    result = type.is_a?(String) || type.nil?

<<<<<<< HEAD
    if result and (type == type.to_f.to_s or type == type.to_i.to_s) then
=======
    if result && (type == type.to_f.to_s || type == type.to_i.to_s)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      return false
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
