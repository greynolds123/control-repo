#
# zip.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:zip, :type => :rvalue, :doc => <<-EOS
Takes one element from first array and merges corresponding elements from second array. This generates a sequence of n-element arrays, where n is one more than the count of arguments.

*Example:*

    zip(['1','2','3'],['4','5','6'])

Would result in:

    ["1", "4"], ["2", "5"], ["3", "6"]
    EOS
  ) do |arguments|

    # Technically we support three arguments but only first is mandatory ...
    raise(Puppet::ParseError, "zip(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2
=======
module Puppet::Parser::Functions
  newfunction(:zip, :type => :rvalue, :doc => <<-DOC
    Takes one element from first array and merges corresponding elements from second array. This generates a sequence of n-element arrays, where n is one more than the count of arguments.

    *Example:*

        zip(['1','2','3'],['4','5','6'])

    Would result in:

        ["1", "4"], ["2", "5"], ["3", "6"]
    DOC
             ) do |arguments|

    # Technically we support three arguments but only first is mandatory ...
    raise(Puppet::ParseError, "zip(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size < 2
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    a = arguments[0]
    b = arguments[1]

<<<<<<< HEAD
    unless a.is_a?(Array) and b.is_a?(Array)
=======
    unless a.is_a?(Array) && b.is_a?(Array)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      raise(Puppet::ParseError, 'zip(): Requires array to work with')
    end

    flatten = function_str2bool([arguments[2]]) if arguments[2]

    result = a.zip(b)
    result = flatten ? result.flatten : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
