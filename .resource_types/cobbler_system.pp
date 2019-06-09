# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Puppet type for cobbler system object
Puppet::Resource::ResourceType3.new(
  'cobbler_system',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Interfaces for the system
    Puppet::Resource::Param(Any, 'interfaces'),

    # Parent profile
    Puppet::Resource::Param(Any, 'profile'),

    # Red Hat authorization key to use to register system
    Puppet::Resource::Param(Any, 'redhat_management_key'),

    # The RHN Satellite or Spacewalk server to use for registration
    Puppet::Resource::Param(Any, 'redhat_management_server'),

    # Server Override
    Puppet::Resource::Param(Any, 'server'),

    # System hostname
    Puppet::Resource::Param(Any, 'hostname'),

    # Netboot Enabled (PXE (re)install this machine at next boot?)
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'netboot_enabled')
  ],
  [
    # A string identifying the system
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `cobbler_system`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Provides cobbler system via cobbler_api
    # 
    #   * Required binaries: `cobbler`.
    #   * Default for `osfamily` == `redhat`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
