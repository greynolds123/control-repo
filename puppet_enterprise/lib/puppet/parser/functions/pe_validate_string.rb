# Namespaced validate_string function from puppetlabs-stdlib
# # https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/validate_string.rb

module Puppet::Parser::Functions

  newfunction(:pe_validate_string, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are string data structures. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $my_string = "one two"
        pe_validate_string($my_string, 'three')

    The following values will fail, causing compilation to abort:

        pe_validate_string(true)
        pe_validate_string([ 'some', 'array' ])

    Note: pe_validate_string(undef) will not fail in this version of the
    functions API (incl. current and future parser). Instead, use:

        if $var == undef {
          fail('...')
        }

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("pe_validate_string(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      unless arg.is_a?(String)
        raise Puppet::ParseError, ("#{arg.inspect} is not a string.  It looks to be a #{arg.class}")
      end
    end

  end

end
