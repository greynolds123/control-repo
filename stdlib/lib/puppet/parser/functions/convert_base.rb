<<<<<<< HEAD
module Puppet::Parser::Functions

  newfunction(:convert_base, :type => :rvalue, :arity => 2, :doc => <<-'ENDHEREDOC') do |args|

=======
#
# convert_base.rb
#
module Puppet::Parser::Functions
  newfunction(:convert_base, :type => :rvalue, :arity => 2, :doc => <<-'DOC') do |args|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    Converts a given integer or base 10 string representing an integer to a specified base, as a string.

    Usage:

      $binary_repr = convert_base(5, 2)  # $binary_repr is now set to "101"
      $hex_repr = convert_base("254", "16")  # $hex_repr is now set to "fe"

<<<<<<< HEAD
    ENDHEREDOC

    raise Puppet::ParseError, ("convert_base(): First argument must be either a string or an integer") unless (args[0].is_a?(Integer) or args[0].is_a?(String))
    raise Puppet::ParseError, ("convert_base(): Second argument must be either a string or an integer") unless (args[1].is_a?(Integer) or args[1].is_a?(String))

    if args[0].is_a?(String)
      raise Puppet::ParseError, ("convert_base(): First argument must be an integer or a string corresponding to an integer in base 10") unless args[0] =~ /^[0-9]+$/
    end

    if args[1].is_a?(String)
      raise Puppet::ParseError, ("convert_base(): First argument must be an integer or a string corresponding to an integer in base 10") unless args[1] =~ /^[0-9]+$/
=======
    DOC

    raise Puppet::ParseError, 'convert_base(): First argument must be either a string or an integer' unless args[0].is_a?(Integer) || args[0].is_a?(String)
    raise Puppet::ParseError, 'convert_base(): Second argument must be either a string or an integer' unless args[1].is_a?(Integer) || args[1].is_a?(String)

    if args[0].is_a?(String)
      raise Puppet::ParseError, 'convert_base(): First argument must be an integer or a string corresponding to an integer in base 10' unless args[0] =~ %r{^[0-9]+$}
    end

    if args[1].is_a?(String)
      raise Puppet::ParseError, 'convert_base(): First argument must be an integer or a string corresponding to an integer in base 10' unless args[1] =~ %r{^[0-9]+$}
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end

    number_to_convert = args[0]
    new_base = args[1]

<<<<<<< HEAD
    number_to_convert = number_to_convert.to_i()
    new_base = new_base.to_i()

    raise Puppet::ParseError, ("convert_base(): base must be at least 2 and must not be greater than 36") unless new_base >= 2 and new_base <= 36
=======
    number_to_convert = number_to_convert.to_i
    new_base = new_base.to_i

    raise Puppet::ParseError, 'convert_base(): base must be at least 2 and must not be greater than 36' unless new_base >= 2 && new_base <= 36
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    return number_to_convert.to_s(new_base)
  end
end
