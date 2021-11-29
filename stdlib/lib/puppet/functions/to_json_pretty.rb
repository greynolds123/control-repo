<<<<<<< HEAD
# Take a data structure and output it as pretty JSON
#
# @example how to output pretty JSON
#   # output pretty json to a file
=======
require 'json'
# @summary
#   Convert data structure and output to pretty JSON
#
# @example **Usage**
#   * how to output pretty JSON to file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json_pretty($myhash),
#     }
#
<<<<<<< HEAD
# @example how to output pretty JSON skipping over keys with undef values
#   # output pretty JSON to a file skipping over undef values
=======
#   * how to output pretty JSON skipping over keys with undef values
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json_pretty({
#         param_one => 'value',
#         param_two => undef,
#       }),
#     }
<<<<<<< HEAD
#
require 'json'

Puppet::Functions.create_function(:to_json_pretty) do
=======
Puppet::Functions.create_function(:to_json_pretty) do
  # @param data
  #   data structure which needs to be converted to pretty json
  # @param skip_undef
  #   value `true` or `false`
  # @return
  #   converted data to pretty json
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  dispatch :to_json_pretty do
    param 'Variant[Hash, Array]', :data
    optional_param 'Boolean', :skip_undef
  end

  def to_json_pretty(data, skip_undef = false)
    if skip_undef
      if data.is_a? Array
        data = data.reject { |value| value.nil? }
      elsif data.is_a? Hash
        data = data.reject { |_, value| value.nil? }
      end
    end
    JSON.pretty_generate(data) << "\n"
  end
end
