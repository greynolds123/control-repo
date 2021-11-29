# Custom Puppet function to convert dos to unix format
module Puppet::Parser::Functions
  newfunction(:dos2unix, :type => :rvalue, :arity => 1, :doc => <<-DOC
<<<<<<< HEAD
    Returns the Unix version of the given string.
    Takes a single string argument.
=======
    @summary
      Returns the Unix version of the given string.

    Takes a single string argument.

    @return The retrieved version
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
    DOC
             ) do |arguments|

    unless arguments[0].is_a?(String)
      raise(Puppet::ParseError, 'dos2unix(): Requires string as argument')
    end

    arguments[0].gsub(%r{\r\n}, "\n")
  end
end
