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
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
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
