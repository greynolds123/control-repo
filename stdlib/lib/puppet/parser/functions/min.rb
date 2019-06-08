#
# min.rb
#
module Puppet::Parser::Functions
  newfunction(:min, :type => :rvalue, :doc => <<-DOC
    Returns the lowest value of all arguments.
    Requires at least one argument.
<<<<<<< HEAD
=======

    Note: from Puppet 6.0.0, the compatible function with the same name in Puppet core
    will be used instead of this function.
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    DOC
             ) do |args|

    raise(Puppet::ParseError, 'min(): Wrong number of arguments need at least one') if args.empty?

    # Sometimes we get numbers as numerics and sometimes as strings.
    # We try to compare them as numbers when possible
    return args.min do |a, b|
      if a.to_s =~ %r{\A^-?\d+(.\d+)?\z} && b.to_s =~ %r{\A-?\d+(.\d+)?\z}
        a.to_f <=> b.to_f
      else
        a.to_s <=> b.to_s
      end
    end
  end
end
