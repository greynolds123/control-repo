#
# dirname.rb
#
module Puppet::Parser::Functions
  newfunction(:dirname, :type => :rvalue, :doc => <<-DOC
    Returns the dirname of a path.
    DOC
             ) do |arguments|

    if arguments.empty?
      raise(Puppet::ParseError, 'dirname(): No arguments given')
    end
    if arguments.size > 1
      raise(Puppet::ParseError, "dirname(): Too many arguments given (#{arguments.size})")
    end
    unless arguments[0].is_a?(String)
      raise(Puppet::ParseError, 'dirname(): Requires string as argument')
    end
<<<<<<< HEAD
=======
    # undef is converted to an empty string ''
    if arguments[0].empty?
      raise(Puppet::ParseError, 'dirname(): Requires a non-empty string as argument')
    end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

    return File.dirname(arguments[0])
  end
end

# vim: set ts=2 sw=2 et :
