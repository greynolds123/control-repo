<<<<<<< HEAD
#
# shell_split.rb
#

require 'shellwords'

module Puppet::Parser::Functions
  newfunction(:shell_split, :type => :rvalue, :doc => <<-EOS
Splits a string into an array of tokens in the same way the Bourne shell does.

This function behaves the same as ruby's Shellwords.shellsplit() function
  EOS
  ) do |arguments|

    raise(Puppet::ParseError, "shell_split(): Wrong number of arguments " +
        "given (#{arguments.size} for 1)") if arguments.size != 1
=======
require 'shellwords'
#
# shell_split.rb
#
module Puppet::Parser::Functions
  newfunction(:shell_split, :type => :rvalue, :doc => <<-DOC
    Splits a string into an array of tokens in the same way the Bourne shell does.

    This function behaves the same as ruby's Shellwords.shellsplit() function
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "shell_split(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    string = arguments[0].to_s

    result = Shellwords.shellsplit(string)

    return result
  end
end

# vim: set ts=2 sw=2 et :
