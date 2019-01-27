#
# str2bool.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:str2bool, :type => :rvalue, :doc => <<-EOS
This converts a string to a boolean. This attempt to convert strings that
contain things like: Y,y, 1, T,t, TRUE,true to 'true' and strings that contain things
like: 0, F,f, N,n, false, FALSE, no to 'false'.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "str2bool(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:str2bool, :type => :rvalue, :doc => <<-DOC
    This converts a string to a boolean. This attempt to convert strings that
    contain things like: Y,y, 1, T,t, TRUE,true to 'true' and strings that contain things
    like: 0, F,f, N,n, false, FALSE, no to 'false'.
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "str2bool(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    string = arguments[0]

    # If string is already Boolean, return it
<<<<<<< HEAD
    if !!string == string
=======
    if !!string == string # rubocop:disable Style/DoubleNegation : No viable alternative
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      return string
    end

    unless string.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'str2bool(): Requires ' +
        'string to work with')
=======
      raise(Puppet::ParseError, 'str2bool(): Requires string to work with')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    # We consider all the yes, no, y, n and so on too ...
    result = case string
<<<<<<< HEAD
      #
      # This is how undef looks like in Puppet ...
      # We yield false in this case.
      #
      when /^$/, '' then false # Empty string will be false ...
      when /^(1|t|y|true|yes)$/i  then true
      when /^(0|f|n|false|no)$/i  then false
      when /^(undef|undefined)$/ then false # This is not likely to happen ...
      else
        raise(Puppet::ParseError, 'str2bool(): Unknown type of boolean given')
    end
=======
             #
             # This is how undef looks like in Puppet ...
             # We yield false in this case.
             #
             when %r{^$}, '' then false # Empty string will be false ...
             when %r{^(1|t|y|true|yes)$}i  then true
             when %r{^(0|f|n|false|no)$}i  then false
             when %r{^(undef|undefined)$} then false # This is not likely to happen ...
             else
               raise(Puppet::ParseError, 'str2bool(): Unknown type of boolean given')
             end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    return result
  end
end

# vim: set ts=2 sw=2 et :
