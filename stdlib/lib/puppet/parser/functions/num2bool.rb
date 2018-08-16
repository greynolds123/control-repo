#
# num2bool.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:num2bool, :type => :rvalue, :doc => <<-EOS
This function converts a number or a string representation of a number into a
true boolean. Zero or anything non-numeric becomes false. Numbers higher then 0
become true.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "num2bool(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1
=======
module Puppet::Parser::Functions
  newfunction(:num2bool, :type => :rvalue, :doc => <<-DOC
    This function converts a number or a string representation of a number into a
    true boolean. Zero or anything non-numeric becomes false. Numbers higher then 0
    become true.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "num2bool(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    number = arguments[0]

    case number
<<<<<<< HEAD
    when Numeric
=======
    when Numeric # rubocop:disable Lint/EmptyWhen : Required for the module to work
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      # Yay, it's a number
    when String
      begin
        number = Float(number)
      rescue ArgumentError => ex
        raise(Puppet::ParseError, "num2bool(): '#{number}' does not look like a number: #{ex.message}")
      end
    else
      begin
        number = number.to_s
      rescue NoMethodError => ex
        raise(Puppet::ParseError, "num2bool(): Unable to parse argument: #{ex.message}")
      end
    end

    # Truncate Floats
    number = number.to_i

    # Return true for any positive number and false otherwise
    return number > 0
  end
end

# vim: set ts=2 sw=2 et :
