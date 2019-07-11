#
# keys.rb
#
module Puppet::Parser::Functions
  newfunction(:keys, :type => :rvalue, :doc => <<-DOC
    Returns the keys of a hash as an array.
<<<<<<< HEAD
=======

    Note: from Puppet 5.5.0, the compatible function with the same name in Puppet core
    will be used instead of this function.
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "keys(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    hash = arguments[0]

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'keys(): Requires hash to work with')
    end

    result = hash.keys

    return result
  end
end

# vim: set ts=2 sw=2 et :
