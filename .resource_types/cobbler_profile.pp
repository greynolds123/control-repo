# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Puppet type for cobbler profile object
Puppet::Resource::ResourceType3.new(
  'cobbler_profile',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Path to kickstart template
    Puppet::Resource::Param(Any, 'kickstart'),

    # Distribution (Parent distribution)
    Puppet::Resource::Param(Any, 'distro'),

    # DHCP tags for multiple networks usage
    Puppet::Resource::Param(Any, 'dhcp_tag'),

    # Repos to auto-assign to this profile
    Puppet::Resource::Param(Any, 'repos'),

    # Kernel Options
    Puppet::Resource::Param(Any, 'kopts'),

    # Governs kernel options on the installed OS
    Puppet::Resource::Param(Any, 'kopts_post'),

    # Sets variables available for use in templates
    Puppet::Resource::Param(Any, 'ksmeta'),

    # How many virtual CPUs should koan give the virtual machine
    Puppet::Resource::Param(Any, 'virt_cpus'),

    # How many megabytes of RAM to consume
    Puppet::Resource::Param(Any, 'virt_ram'),

    # Virtualization technology to use
    # 
    # Valid values are `xenpv`, `xenfv`, `qemu`, `kvm`, `vmware`, `openvz`.
    Puppet::Resource::Param(Enum['xenpv', 'xenfv', 'qemu', 'kvm', 'vmware', 'openvz'], 'virt_type')
  ],
  [
    # A string identifying the profile
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `cobbler_profile`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Provides cobbler profile via cobbler_api
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
