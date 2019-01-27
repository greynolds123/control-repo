#
# delete_at.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:delete_at, :type => :rvalue, :doc => <<-EOS
Deletes a determined indexed value from an array.

*Examples:*

    delete_at(['a','b','c'], 1)

Would return: ['a','c']
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "delete_at(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2
=======
module Puppet::Parser::Functions
  newfunction(:delete_at, :type => :rvalue, :doc => <<-DOC
    Deletes a determined indexed value from an array.

    *Examples:*

        delete_at(['a','b','c'], 1)

    Would return: ['a','c']
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "delete_at(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size < 2
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'delete_at(): Requires array to work with')
    end

    index = arguments[1]

<<<<<<< HEAD
    if index.is_a?(String) and not index.match(/^\d+$/)
      raise(Puppet::ParseError, 'delete_at(): You must provide ' +
        'non-negative numeric index')
=======
    if index.is_a?(String) && !index.match(%r{^\d+$})
      raise(Puppet::ParseError, 'delete_at(): You must provide non-negative numeric index')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    result = array.clone

    # Numbers in Puppet are often string-encoded which is troublesome ...
    index = index.to_i

    if index > result.size - 1 # First element is at index 0 is it not?
<<<<<<< HEAD
      raise(Puppet::ParseError, 'delete_at(): Given index ' +
        'exceeds size of array given')
=======
      raise(Puppet::ParseError, 'delete_at(): Given index exceeds size of array given')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    result.delete_at(index) # We ignore the element that got deleted ...

    return result
  end
end

# vim: set ts=2 sw=2 et :
