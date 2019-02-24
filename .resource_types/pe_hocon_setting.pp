# This file was automatically generated on 2017-02-13 04:11:50 -0800.
# Use the 'puppet generate types' command to regenerate this file.

Puppet::Resource::ResourceType3.new(
  'pe_hocon_setting',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The value type
    Puppet::Resource::Param(Any, 'type'),

    # The value of the setting to be defined.
    Puppet::Resource::Param(Any, 'value')
  ],
  [
    # An arbitrary name used as the identity of the resource.
    Puppet::Resource::Param(Any, 'name', true),

    # The name of the setting to be defined.
    Puppet::Resource::Param(Any, 'setting'),

    # The file Puppet will ensure contains the specified setting.
    Puppet::Resource::Param(Any, 'path'),

    # The specific backend to use for this `pe_hocon_setting`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(.*)/ => ['name']
  },
  true,
  false)
