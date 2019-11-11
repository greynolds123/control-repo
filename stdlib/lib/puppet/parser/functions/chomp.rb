#
#  chomp.rb
#
module Puppet::Parser::Functions
  newfunction(:chomp, :type => :rvalue, :doc => <<-DOC
    Removes the record separator from the end of a string or an array of
    strings, for example `hello\n` becomes `hello`.
    Requires a single string or array as an input.
<<<<<<< HEAD
=======

    Note: from Puppet 6.0.0, the compatible function with the same name in Puppet core
    will be used instead of this function.
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "chomp(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'chomp(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
               value.map { |i| i.is_a?(String) ? i.chomp : i }
             else
               value.chomp
             end

    return result
  end
end

# vim: set ts=2 sw=2 et :
