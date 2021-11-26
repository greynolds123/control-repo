module Puppet::Parser::Functions

  newfunction(:pe_validate_hash, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are hash data structures. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $my_hash = { 'one' => 'two' }
        pe_validate_hash($my_hash)

    The following values will fail, causing compilation to abort:

        pe_validate_hash(true)
        pe_validate_hash('some_string')
        $undefined = undef
        pe_validate_hash($undefined)

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("pe_validate_hash(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, ("#{arg.inspect} is not a Hash.  It looks to be a #{arg.class}")
      end
    end

  end

end
