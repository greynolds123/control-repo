#
# bool2str.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:bool2str, :type => :rvalue, :doc => <<-EOS
=======
module Puppet::Parser::Functions
  newfunction(:bool2str, :type => :rvalue, :doc => <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Converts a boolean to a string using optionally supplied arguments. The
    optional second and third arguments represent what true and false will be
    converted to respectively. If only one argument is given, it will be
    converted from a boolean to a string containing 'true' or 'false'.

    *Examples:*

    bool2str(true)                    => 'true'
    bool2str(true, 'yes', 'no')       => 'yes'
    bool2str(false, 't', 'f')         => 'f'

    Requires a single boolean as an input.
<<<<<<< HEAD
    EOS
  ) do |arguments|

    unless arguments.size == 1 or arguments.size == 3
      raise(Puppet::ParseError, "bool2str(): Wrong number of arguments " +
                                "given (#{arguments.size} for 3)")
=======
    DOC
             ) do |arguments|

    unless arguments.size == 1 || arguments.size == 3
      raise(Puppet::ParseError, "bool2str(): Wrong number of arguments given (#{arguments.size} for 3)")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    value = arguments[0]
    true_string = arguments[1] || 'true'
    false_string = arguments[2] || 'false'
    klass = value.class

    # We can have either true or false, and nothing else
    unless [FalseClass, TrueClass].include?(klass)
      raise(Puppet::ParseError, 'bool2str(): Requires a boolean to work with')
    end

<<<<<<< HEAD
    unless [true_string, false_string].all?{|x| x.kind_of?(String)}
      raise(Puppet::ParseError, "bool2str(): Requires strings to convert to" )
=======
    unless [true_string, false_string].all? { |x| x.is_a?(String) }
      raise(Puppet::ParseError, 'bool2str(): Requires strings to convert to')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    return value ? true_string : false_string
  end
end

# vim: set ts=2 sw=2 et :
