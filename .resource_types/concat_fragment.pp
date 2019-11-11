# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Create a concat fragment to be used by concat.
# the `concat_fragment` type creates a file fragment to be collected by concat based on the tag.
# The example is based on exported resources.
# 
# Example:
# @@concat_fragment { "uniqe_name_${::fqdn}":
#   tag => 'unique_name',
#   order => 10, # Optional. Default to 10
#   content => 'some content' # OR
#   content => template('template.erb') # OR
#   source  => 'puppet:///path/to/file'
# }
Puppet::Resource::ResourceType3.new(
  'concat_fragment',
  [

  ],
  [
    # Unique name
    Puppet::Resource::Param(Any, 'name', true),

    # Target
    Puppet::Resource::Param(Any, 'target'),

    # Content
    Puppet::Resource::Param(Any, 'content'),

    # Source
    Puppet::Resource::Param(Any, 'source'),

    # Order
    Puppet::Resource::Param(Any, 'order'),

    # Tag name to be used by concat to collect all concat_fragments by tag name
    Puppet::Resource::Param(Any, 'tag')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
