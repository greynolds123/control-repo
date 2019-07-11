#
# difference.rb
#
module Puppet::Parser::Functions
  newfunction(:difference, :type => :rvalue, :doc => <<-DOC
    This function returns the difference between two arrays.
    The returned array is a copy of the original array, removing any items that
    also appear in the second array.

    *Examples:*

        difference(["a","b","c"],["b","c","d"])

    Would return: ["a"]
<<<<<<< HEAD
=======

    Note: Since Puppet 4 the minus (-) operator in the Puppet language does the same thing:

      ['a', 'b', 'c'] - ['b', 'c', 'd']
      # would return ['a']

>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    DOC
             ) do |arguments|

    # Two arguments are required
    raise(Puppet::ParseError, "difference(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size != 2

    first = arguments[0]
    second = arguments[1]

    unless first.is_a?(Array) && second.is_a?(Array)
      raise(Puppet::ParseError, 'difference(): Requires 2 arrays')
    end

    result = first - second

    return result
  end
end

# vim: set ts=2 sw=2 et :
