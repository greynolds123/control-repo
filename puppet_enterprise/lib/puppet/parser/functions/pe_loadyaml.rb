module Puppet::Parser::Functions

  newfunction(:pe_loadyaml, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Load a YAML file containing an array, string, or hash, and return the data
    in the corresponding native data type.

    For example:

        $myhash = pe_loadyaml('/etc/puppet/data/myhash.yaml')
    ENDHEREDOC

    unless args.length == 1
      raise Puppet::ParseError, ("pe_loadyaml(): wrong number of arguments (#{args.length}; must be 1)")
    end

    YAML.load_file(args[0])

  end

end
