#
# floor.rb
#
module Puppet::Parser::Functions
  newfunction(:floor, :type => :rvalue, :doc => <<-DOC
    Returns the largest integer less or equal to the argument.
    Takes a single numeric value as an argument.
<<<<<<< HEAD
=======

    Note: from Puppet 6.0.0, the compatible function with the same name in Puppet core
    will be used instead of this function.
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "floor(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    begin
      arg = Float(arguments[0])
    rescue TypeError, ArgumentError => _e
      raise(Puppet::ParseError, "floor(): Wrong argument type given (#{arguments[0]} for Numeric)")
    end

    raise(Puppet::ParseError, "floor(): Wrong argument type given (#{arg.class} for Numeric)") if arg.is_a?(Numeric) == false

    arg.floor
  end
end

# vim: set ts=2 sw=2 et :
