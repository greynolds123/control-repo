<<<<<<< HEAD
# Take a data structure and output it as JSON
=======
require 'json'
# @summary
#   Convert a data structure and output to JSON
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
#
# @example how to output JSON
#   # output json to a file
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json($myhash),
#     }
#
<<<<<<< HEAD
#
require 'json'

Puppet::Functions.create_function(:to_json) do
=======
Puppet::Functions.create_function(:to_json) do
  # @param data
  #   data structure which needs to be converted into JSON
  # @return converted data to json
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  dispatch :to_json do
    param 'Any', :data
  end

  def to_json(data)
    data.to_json
  end
end
