#
# pe_validate_bool.rb
#

module Puppet::Parser::Functions
  newfunction(:pe_validate_single_integer, :doc => <<-'ENDHEREDOC') do |args|
    Validate that the passed value is an integer, or an integer in string form.
    Abort catalog compilation if any value fails the check.

    ENDHEREDOC

    unless args.length == 1 then
      raise Puppet::ParseError, ("pe_validate_single_integer(): wrong number of arguments (#{args.length}; must be 1)")
    end

    unless function_pe_is_integer([args[0]])
      raise Puppet::ParseError, ("#{args[0].inspect} is not an integer. It looks to be a #{args[0].class}")
    end
  end
end


