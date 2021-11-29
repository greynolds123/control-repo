#
# any2bool.rb
#
module Puppet::Parser::Functions
  newfunction(:any2bool, :type => :rvalue, :doc => <<-DOC
<<<<<<< HEAD
    This converts 'anything' to a boolean. In practise it does the following:

=======
    @summary
      Converts 'anything' to a boolean.

    In practise it does the following:
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
    * Strings such as Y,y,1,T,t,TRUE,yes,'true' will return true
    * Strings such as 0,F,f,N,n,FALSE,no,'false' will return false
    * Booleans will just return their original value
    * Number (or a string representation of a number) > 0 will return true, otherwise false
    * undef will return false
    * Anything else will return true

    Also see the built-in [`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean)
    function.
<<<<<<< HEAD
=======

    @return [Boolean] The boolean value of the object that was given
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "any2bool(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    # If argument is already Boolean, return it
    if !!arguments[0] == arguments[0] # rubocop:disable Style/DoubleNegation : Could not find a better way to check if a boolean
      return arguments[0]
    end

    arg = arguments[0]

    if arg.nil?
      return false
    end

    if arg == :undef
      return false
    end

    valid_float = begin
                    !!Float(arg) # rubocop:disable Style/DoubleNegation : Could not find a better way to check if a boolean
                  rescue
                    false
                  end

    if arg.is_a?(Numeric)
      return function_num2bool([arguments[0]])
    end

    if arg.is_a?(String)
      return function_num2bool([arguments[0]]) if valid_float
      return function_str2bool([arguments[0]])
    end

    return true
  end
end

# vim: set ts=2 sw=2 et :
