<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:load_module_metadata, :type => :rvalue, :doc => <<-EOT
  EOT
  ) do |args|
    raise(Puppet::ParseError, "load_module_metadata(): Wrong number of arguments, expects one or two") unless [1,2].include?(args.size)
=======
#
# load_module_metadata.rb
#
module Puppet::Parser::Functions
  newfunction(:load_module_metadata, :type => :rvalue, :doc => <<-DOC
    This function loads the metadata of a given module.
  DOC
             ) do |args|
    raise(Puppet::ParseError, 'load_module_metadata(): Wrong number of arguments, expects one or two') unless [1, 2].include?(args.size)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    mod = args[0]
    allow_empty_metadata = args[1]
    module_path = function_get_module_path([mod])
    metadata_json = File.join(module_path, 'metadata.json')

<<<<<<< HEAD
    metadata_exists = File.exists?(metadata_json)
    if metadata_exists
      metadata = PSON.load(File.read(metadata_json))
    else
      if allow_empty_metadata
        metadata = {}
      else
        raise(Puppet::ParseError, "load_module_metadata(): No metadata.json file for module #{mod}")
      end
=======
    metadata_exists = File.exists?(metadata_json) # rubocop:disable Lint/DeprecatedClassMethods : Changing to .exist? breaks the code
    if metadata_exists
      metadata = PSON.load(File.read(metadata_json))
    else
      metadata = {}
      raise(Puppet::ParseError, "load_module_metadata(): No metadata.json file for module #{mod}") unless allow_empty_metadata
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end

    return metadata
  end
end
