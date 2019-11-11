#
#  ceiling.rb
#
module Puppet::Parser::Functions
  newfunction(:ceiling, :type => :rvalue, :doc => <<-DOC
    Returns the smallest integer greater or equal to the argument.
    Takes a single numeric value as an argument.
<<<<<<< HEAD
=======

    Note: from Puppet 6.0.0, the compatible function with the same name in Puppet core
    will be used instead of this function.
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "ceiling(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    begin
      arg = Float(arguments[0])
    rescue TypeError, ArgumentError => _e
      raise(Puppet::ParseError, "ceiling(): Wrong argument type given (#{arguments[0]} for Numeric)")
    end

    raise(Puppet::ParseError, "ceiling(): Wrong argument type given (#{arg.class} for Numeric)") if arg.is_a?(Numeric) == false

    arg.ceil
  end
end

# vim: set ts=2 sw=2 et :
