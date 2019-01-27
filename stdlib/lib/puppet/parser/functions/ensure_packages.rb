#
# ensure_packages.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:ensure_packages, :type => :statement, :doc => <<-EOS
Takes a list of packages and only installs them if they don't already exist.
It optionally takes a hash as a second parameter that will be passed as the
third argument to the ensure_resource() function.
    EOS
  ) do |arguments|

    if arguments.size > 2 or arguments.size == 0
      raise(Puppet::ParseError, "ensure_packages(): Wrong number of arguments " +
        "given (#{arguments.size} for 1 or 2)")
    elsif arguments.size == 2 and !arguments[1].is_a?(Hash) 
      raise(Puppet::ParseError, 'ensure_packages(): Requires second argument to be a Hash')
    end
=======
module Puppet::Parser::Functions
  newfunction(:ensure_packages, :type => :statement, :doc => <<-DOC
    Takes a list of packages and only installs them if they don't already exist.
    It optionally takes a hash as a second parameter that will be passed as the
    third argument to the ensure_resource() function.
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "ensure_packages(): Wrong number of arguments given (#{arguments.size} for 1 or 2)") if arguments.size > 2 || arguments.empty?
    raise(Puppet::ParseError, 'ensure_packages(): Requires second argument to be a Hash') if arguments.size == 2 && !arguments[1].is_a?(Hash)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    if arguments[0].is_a?(Hash)
      if arguments[1]
        defaults = { 'ensure' => 'present' }.merge(arguments[1])
<<<<<<< HEAD
=======
        if defaults['ensure'] == 'installed'
          defaults['ensure'] = 'present'
        end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      else
        defaults = { 'ensure' => 'present' }
      end

      Puppet::Parser::Functions.function(:ensure_resources)
<<<<<<< HEAD
      function_ensure_resources(['package', Hash(arguments[0]), defaults ])
=======
      function_ensure_resources(['package', arguments[0].dup, defaults])
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    else
      packages = Array(arguments[0])

      if arguments[1]
        defaults = { 'ensure' => 'present' }.merge(arguments[1])
<<<<<<< HEAD
=======
        if defaults['ensure'] == 'installed'
          defaults['ensure'] = 'present'
        end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      else
        defaults = { 'ensure' => 'present' }
      end

      Puppet::Parser::Functions.function(:ensure_resource)
<<<<<<< HEAD
      packages.each { |package_name|
        function_ensure_resource(['package', package_name, defaults ])
    }
=======
      packages.each do |package_name|
        raise(Puppet::ParseError, 'ensure_packages(): Empty String provided for package name') if package_name.empty?
        unless findresource("Package[#{package_name}]")
          function_ensure_resource(['package', package_name, defaults])
        end
      end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end

# vim: set ts=2 sw=2 et :
