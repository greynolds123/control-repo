<<<<<<< HEAD
# Take a data structure and output it as YAML
=======
require 'yaml'
# @summary
#   Convert a data structure and output it as YAML
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
#
# @example how to output YAML
#   # output yaml to a file
#     file { '/tmp/my.yaml':
#       ensure  => file,
#       content => to_yaml($myhash),
#     }
<<<<<<< HEAD
#
#
require 'yaml'

Puppet::Functions.create_function(:to_yaml) do
=======
Puppet::Functions.create_function(:to_yaml) do
  # @param data
  #
  # @return [String]
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  dispatch :to_yaml do
    param 'Any', :data
  end

  def to_yaml(data)
    data.to_yaml
  end
end
