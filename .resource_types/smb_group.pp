# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

Puppet::Resource::ResourceType3.new(
  'smb_group',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # Name of the group
    Puppet::Resource::Param(Any, 'name', true),

    # hash of attributes
    Puppet::Resource::Param(Any, 'attributes'),

    # list of groups
    Puppet::Resource::Param(Any, 'groups'),

    # scope of the group
    Puppet::Resource::Param(Any, 'scope'),

    # scope of the group
    Puppet::Resource::Param(Any, 'type'),

    # The specific backend to use for this `smb_group`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : * Required binaries: `/usr/bin/samba-tool`, `/usr/bin/smbclient`, `/usr/local/bin/additional-samba-tool`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
