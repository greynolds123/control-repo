# Custom Puppet function to convert dos to unix format
module Puppet::Parser::Functions
<<<<<<< HEAD
  newfunction(:dos2unix, :type => :rvalue, :arity => 1, :doc => <<-EOS
    Returns the Unix version of the given string.
    Takes a single string argument.
    EOS
  ) do |arguments|
=======
  newfunction(:dos2unix, :type => :rvalue, :arity => 1, :doc => <<-DOC
    Returns the Unix version of the given string.
    Takes a single string argument.
    DOC
             ) do |arguments|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    unless arguments[0].is_a?(String)
      raise(Puppet::ParseError, 'dos2unix(): Requires string as argument')
    end

<<<<<<< HEAD
    arguments[0].gsub(/\r\n/, "\n")
=======
    arguments[0].gsub(%r{\r\n}, "\n")
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end
end
