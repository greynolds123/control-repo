<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:ceiling, :type => :rvalue, :doc => <<-EOS
    Returns the smallest integer greater or equal to the argument.
    Takes a single numeric value as an argument.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "ceiling(): Wrong number of arguments " +
          "given (#{arguments.size} for 1)") if arguments.size != 1

    begin
      arg = Float(arguments[0])
    rescue TypeError, ArgumentError => e
      raise(Puppet::ParseError, "ceiling(): Wrong argument type " +
            "given (#{arguments[0]} for Numeric)")
    end

    raise(Puppet::ParseError, "ceiling(): Wrong argument type " +
          "given (#{arg.class} for Numeric)") if arg.is_a?(Numeric) == false
=======
#
#  ceiling.rb
#
module Puppet::Parser::Functions
  newfunction(:ceiling, :type => :rvalue, :doc => <<-DOC
    Returns the smallest integer greater or equal to the argument.
    Takes a single numeric value as an argument.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "ceiling(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    begin
      arg = Float(arguments[0])
    rescue TypeError, ArgumentError => _e
      raise(Puppet::ParseError, "ceiling(): Wrong argument type given (#{arguments[0]} for Numeric)")
    end

    raise(Puppet::ParseError, "ceiling(): Wrong argument type given (#{arg.class} for Numeric)") if arg.is_a?(Numeric) == false
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    arg.ceil
  end
end

# vim: set ts=2 sw=2 et :
