#
<<<<<<< HEAD
# upcase.rb
#

module Puppet::Parser::Functions
  newfunction(:upcase, :type => :rvalue, :doc => <<-EOS
Converts a string or an array of strings to uppercase.

*Examples:*

    upcase("abcd")

Will return:

    ABCD
  EOS
  ) do |arguments|

    raise(Puppet::ParseError, "upcase(): Wrong number of arguments " +
                                "given (#{arguments.size} for 1)") if arguments.size != 1
=======
#  upcase.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
module Puppet::Parser::Functions
  newfunction(:upcase, :type => :rvalue, :doc => <<-DOC
    Converts a string or an array of strings to uppercase.

    *Examples:*

        upcase("abcd")

    Will return:

        ABCD
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "upcase(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(Hash) || value.respond_to?(:upcase)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'upcase(): Requires an ' +
                                  'array, hash or object that responds to upcase in order to work')
=======
      raise(Puppet::ParseError, 'upcase(): Requires an array, hash or object that responds to upcase in order to work')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
<<<<<<< HEAD
      result = value.collect { |i| function_upcase([i]) }
=======
      result = value.map { |i| function_upcase([i]) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    elsif value.is_a?(Hash)
      result = {}
      value.each_pair do |k, v|
        result[function_upcase([k])] = function_upcase([v])
      end
    else
      result = value.upcase
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
