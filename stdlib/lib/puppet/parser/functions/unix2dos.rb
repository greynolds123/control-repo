# Custom Puppet function to convert unix to dos format
module Puppet::Parser::Functions
<<<<<<< HEAD
  newfunction(:unix2dos, :type => :rvalue, :arity => 1, :doc => <<-EOS
    Returns the DOS version of the given string.
    Takes a single string argument.
    EOS
  ) do |arguments|
=======
  newfunction(:unix2dos, :type => :rvalue, :arity => 1, :doc => <<-DOC
    Returns the DOS version of the given string.
    Takes a single string argument.
    DOC
             ) do |arguments|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    unless arguments[0].is_a?(String)
      raise(Puppet::ParseError, 'unix2dos(): Requires string as argument')
    end

<<<<<<< HEAD
    arguments[0].gsub(/\r*\n/, "\r\n")
=======
    arguments[0].gsub(%r{\r*\n}, "\r\n")
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end
end
