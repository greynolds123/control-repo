<<<<<<< HEAD
module Puppet::Parser::Functions

  newfunction(:getvar, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
=======
#
# getvar.rb
#
module Puppet::Parser::Functions
  newfunction(:getvar, :type => :rvalue, :doc => <<-'DOC') do |args|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    Lookup a variable in a remote namespace.

    For example:

        $foo = getvar('site::data::foo')
        # Equivalent to $foo = $site::data::foo

    This is useful if the namespace itself is stored in a string:

        $datalocation = 'site::data'
        $bar = getvar("${datalocation}::bar")
        # Equivalent to $bar = $site::data::bar
<<<<<<< HEAD
    ENDHEREDOC

    unless args.length == 1
      raise Puppet::ParseError, ("getvar(): wrong number of arguments (#{args.length}; must be 1)")
=======
    DOC

    unless args.length == 1
      raise Puppet::ParseError, "getvar(): wrong number of arguments (#{args.length}; must be 1)"
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end

    begin
      result = nil
      catch(:undefined_variable) do
<<<<<<< HEAD
        result = self.lookupvar("#{args[0]}")
=======
        result = lookupvar((args[0]).to_s)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end

      # avoid relying on incosistent behaviour around ruby return values from catch
      result
<<<<<<< HEAD
    rescue Puppet::ParseError # Eat the exception if strict_variables = true is set
    end

  end

=======
    rescue Puppet::ParseError # rubocop:disable Lint/HandleExceptions : Eat the exception if strict_variables = true is set
    end
  end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
