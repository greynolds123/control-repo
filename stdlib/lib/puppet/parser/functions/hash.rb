#
# hash.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:hash, :type => :rvalue, :doc => <<-EOS
This function converts an array into a hash.

*Examples:*

    hash(['a',1,'b',2,'c',3])

Would return: {'a'=>1,'b'=>2,'c'=>3}
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "hash(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:hash, :type => :rvalue, :doc => <<-DOC
    This function converts an array into a hash.

    *Examples:*

        hash(['a',1,'b',2,'c',3])

    Would return: {'a'=>1,'b'=>2,'c'=>3}
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "hash(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'hash(): Requires array to work with')
    end

    result = {}

    begin
      # This is to make it compatible with older version of Ruby ...
      array  = array.flatten
      result = Hash[*array]
    rescue StandardError
<<<<<<< HEAD
      raise(Puppet::ParseError, 'hash(): Unable to compute ' +
        'hash from array given')
=======
      raise(Puppet::ParseError, 'hash(): Unable to compute hash from array given')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
