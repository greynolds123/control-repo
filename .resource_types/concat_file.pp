# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Gets all the file fragments and puts these into the target file.
# This will mostly be used with exported resources.
# 
# example:
#   Concat_fragment <<| tag == 'unique_tag' |>>
# 
#   concat_file { '/tmp/file':
#     tag            => 'unique_tag', # Mandatory
#     path           => '/tmp/file',  # Optional. If given it overrides the resource name
#     owner          => 'root',       # Optional. Default to undef
#     group          => 'root',       # Optional. Default to undef
#     mode           => '0644'        # Optional. Default to undef
#     order          => 'numeric'     # Optional, Default to 'numeric'
#     ensure_newline => false         # Optional, Defaults to false
#   }
Puppet::Resource::ResourceType3.new(
  'concat_file',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # Resource name
    Puppet::Resource::Param(Any, 'name', true),

    # Tag reference to collect all concat_fragment's with the same tag
    Puppet::Resource::Param(Any, 'tag'),

    # The output file
    Puppet::Resource::Param(Any, 'path'),

    # Desired file owner.
    Puppet::Resource::Param(Any, 'owner'),

    # Desired file group.
    Puppet::Resource::Param(Any, 'group'),

    # Desired file mode.
    Puppet::Resource::Param(Any, 'mode'),

    # Controls the ordering of fragments. Can be set to alphabetical or numeric.
    Puppet::Resource::Param(Any, 'order'),

    # Controls the filebucketing behavior of the final file and see File type reference for its use.
    Puppet::Resource::Param(Any, 'backup'),

    # Whether to replace a file that already exists on the local system.
    Puppet::Resource::Param(Any, 'replace'),

    # Validates file.
    Puppet::Resource::Param(Any, 'validate_cmd'),

    # Whether to ensure there is a newline after each fragment.
    Puppet::Resource::Param(Any, 'ensure_newline'),

    Puppet::Resource::Param(Any, 'selinux_ignore_defaults'),

    Puppet::Resource::Param(Any, 'selrange'),

    Puppet::Resource::Param(Any, 'selrole'),

    Puppet::Resource::Param(Any, 'seltype'),

    Puppet::Resource::Param(Any, 'seluser'),

    Puppet::Resource::Param(Any, 'show_diff')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
