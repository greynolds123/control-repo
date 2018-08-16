#
# is_function_available.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:is_function_available, :type => :rvalue, :doc => <<-EOS
This function accepts a string as an argument, determines whether the
Puppet runtime has access to a function by that name.  It returns a
true if the function exists, false if not.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_function_available?(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
=======
module Puppet::Parser::Functions
  newfunction(:is_function_available, :type => :rvalue, :doc => <<-DOC
    This function accepts a string as an argument, determines whether the
    Puppet runtime has access to a function by that name.  It returns a
    true if the function exists, false if not.
    DOC
             ) do |arguments|

    if arguments.size != 1
      raise(Puppet::ParseError, "is_function_available?(): Wrong number of arguments given #{arguments.size} for 1")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    # Only allow String types
    return false unless arguments[0].is_a?(String)

    function = Puppet::Parser::Functions.function(arguments[0].to_sym)
<<<<<<< HEAD
    function.is_a?(String) and not function.empty?
=======
    function.is_a?(String) && !function.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end

# vim: set ts=2 sw=2 et :
