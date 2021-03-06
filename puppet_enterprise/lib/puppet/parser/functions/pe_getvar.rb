module Puppet::Parser::Functions

  newfunction(:pe_getvar, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Lookup a variable in a remote namespace.

    For example:

        $foo = pe_getvar('site::data::foo')
        # Equivalent to $foo = $site::data::foo

    This is useful if the namespace itself is stored in a string:

        $datalocation = 'site::data'
        $bar = pe_getvar("${datalocation}::bar")
        # Equivalent to $bar = $site::data::bar
    ENDHEREDOC

    unless args.length == 1
      raise Puppet::ParseError, ("pe_getvar(): wrong number of arguments (#{args.length}; must be 1)")
    end

    begin
      catch(:undefined_variable) do
        self.lookupvar("#{args[0]}")
      end
    rescue Puppet::ParseError # Eat the exception if strict_variables = true is set
    end

  end

end
