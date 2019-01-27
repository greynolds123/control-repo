<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:loadyaml, :type => :rvalue, :arity => -2, :doc => <<-'ENDHEREDOC') do |args|
Load a YAML file containing an array, string, or hash, and return the data
in the corresponding native data type.
The second parameter is the default value. It will be returned if the file
was not found or could not be parsed.

For example:

    $myhash = loadyaml('/etc/puppet/data/myhash.yaml')
    $myhash = loadyaml('no-file.yaml', {'default' => 'value'})
  ENDHEREDOC
=======
#
# loadyaml.rb
#
module Puppet::Parser::Functions
  newfunction(:loadyaml, :type => :rvalue, :arity => -2, :doc => <<-'DOC') do |args|
    Load a YAML file containing an array, string, or hash, and return the data
    in the corresponding native data type.
    The second parameter is the default value. It will be returned if the file
    was not found or could not be parsed.

    For example:

        $myhash = loadyaml('/etc/puppet/data/myhash.yaml')
        $myhash = loadyaml('no-file.yaml', {'default' => 'value'})
  DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    raise ArgumentError, 'Wrong number of arguments. 1 or 2 arguments should be provided.' unless args.length >= 1
    require 'yaml'

<<<<<<< HEAD
    if File.exists?(args[0])
      begin
        YAML::load_file(args[0]) || args[1]
      rescue Exception => e
        if args[1]
          args[1]
        else
          raise e
        end
=======
    if File.exists?(args[0]) # rubocop:disable Lint/DeprecatedClassMethods : Changing to .exist? breaks the code
      begin
        YAML.load_file(args[0]) || args[1]
      rescue StandardError => e
        raise e unless args[1]
        args[1]
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    else
      warning("Can't load '#{args[0]}' File does not exist!")
      args[1]
    end
<<<<<<< HEAD

  end

=======
  end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
