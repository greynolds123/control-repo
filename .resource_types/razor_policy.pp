# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Razor Policy
Puppet::Resource::ResourceType3.new(
  'razor_policy',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The repository to install from
    Puppet::Resource::Param(Any, 'repo'),

    # The task to use to install the repo
    Puppet::Resource::Param(Any, 'task'),

    # The broker to use after installation
    Puppet::Resource::Param(Any, 'broker'),

    # The hostname to set up (use ${id} inside)
    Puppet::Resource::Param(Any, 'hostname'),

    # The root password to install with
    Puppet::Resource::Param(Any, 'root_password'),

    # The maximum hosts to configure (set nil for unlimited)
    # 
    # Values can match `/^\d+$/`.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'max_count'),

    # The policy before this one
    Puppet::Resource::Param(Any, 'before_policy'),

    # The policy after this one
    Puppet::Resource::Param(Any, 'after_policy'),

    # The node metadata [Hash]
    Puppet::Resource::Param(Any, 'node_metadata'),

    # The tags to look for [Array]
    Puppet::Resource::Param(Any, 'tags'),

    # Policies can be enabled or disabled
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'enabled')
  ],
  [
    # The policy name
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `razor_policy`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # rest
    # : REST provider for Razor policy
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
