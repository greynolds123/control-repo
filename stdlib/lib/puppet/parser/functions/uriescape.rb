<<<<<<< HEAD
#
#  uriescape.rb
#
require 'uri'

module Puppet::Parser::Functions
  newfunction(:uriescape, :type => :rvalue, :doc => <<-EOS
    Urlencodes a string or array of strings.
    Requires either a single string or an array as an input.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "uriescape(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
require 'uri'
#
#  uriescape.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
module Puppet::Parser::Functions
  newfunction(:uriescape, :type => :rvalue, :doc => <<-DOC
    Urlencodes a string or array of strings.
    Requires either a single string or an array as an input.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "uriescape(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'uriescape(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? URI.escape(i) : i }
    else
      result = URI.escape(value)
    end
=======
      raise(Puppet::ParseError, 'uriescape(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
               value.map { |i| i.is_a?(String) ? URI.escape(i) : i }
             else
               URI.escape(value)
             end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    return result
  end
end

# vim: set ts=2 sw=2 et :
