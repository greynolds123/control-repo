<<<<<<< HEAD
module Puppet::Parser::Functions

  newfunction(:getvar, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
=======
#
# getvar.rb
#
module Puppet::Parser::Functions
  newfunction(:getvar, :type => :rvalue, :doc => <<-'DOC') do |args|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    begin
      result = nil
      catch(:undefined_variable) do
<<<<<<< HEAD
        result = self.lookupvar("#{args[0]}")
=======
        result = lookupvar((args[0]).to_s)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
