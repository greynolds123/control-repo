# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Puppet type for cobbler distro object
Puppet::Resource::ResourceType3.new(
  'cobbler_distro',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Sets the architecture for the PXE bootloader
    # 
    # Valid values are `i386`, `x86_64`, `ia64`, `ppc`, `ppc64`, `s390`, `arm`.
    Puppet::Resource::Param(Enum['i386', 'x86_64', 'ia64', 'ppc', 'ppc64', 's390', 'arm'], 'arch'),

    # List of users and groups as specified in /etc/cobbler/users.conf
    Puppet::Resource::Param(Any, 'owners'),

    # An absolute filesystem path to a kernel image
    Puppet::Resource::Param(Any, 'kernel'),

    # Sets variables available for use in templates
    Puppet::Resource::Param(Any, 'ksmeta'),

    # An absolute filesystem path to a initrd image
    Puppet::Resource::Param(Any, 'initrd'),

    # An optional comment to associate with this distro
    Puppet::Resource::Param(Any, 'comment')
  ],
  [
    # A string identifying the distribution
    Puppet::Resource::Param(Any, 'name', true),

    # Local path or rsync location
    Puppet::Resource::Param(Any, 'path'),

    # The specific backend to use for this `cobbler_distro`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Provides cobbler distro via cobbler_api
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
