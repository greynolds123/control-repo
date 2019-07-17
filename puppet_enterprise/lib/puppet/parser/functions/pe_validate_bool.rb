# Namespaced validate_bool function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/validate_bool.rb

module Puppet::Parser::Functions

  newfunction(:pe_validate_bool, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are either true or false. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $iamtrue = true
        pe_validate_bool(true)
        pe_validate_bool(true, true, false, $iamtrue)

    The following values will fail, causing compilation to abort:

        $some_array = [ true ]
        pe_validate_bool("false")
        pe_validate_bool("true")
        pe_validate_bool($some_array)

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("pe_validate_bool(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      unless function_pe_is_bool([arg])
        raise Puppet::ParseError, ("#{arg.inspect} is not a boolean.  It looks to be a #{arg.class}")
      end
    end

  end

end
