# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manages global GRUB configuration parameters
Puppet::Resource::ResourceType3.new(
  'grub_config',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Value of the GRUB parameter.
    Puppet::Resource::Param(Any, 'value')
  ],
  [
    # The parameter that you wish to set.
    # 
    # ## GRUB < 2 ##
    # 
    # In the case of GRUB < 2, this will be something like 'default',
    # 'timeout', etc...
    # 
    # See `info grub` for additional information.
    # 
    # ## GRUB >= 2 ##
    # 
    # With GRUB >= 2, this will be 'GRUB_DEFAULT', 'GRUB_SAVEDEFAULT', etc..
    # 
    # See `info grub2` for additional information.
    Puppet::Resource::Param(Any, 'name', true),

    # The bootloader configuration file, if in a non-default location for the
    # provider.
    Puppet::Resource::Param(Any, 'target'),

    # The specific backend to use for this `grub_config`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # grub
    # : Uses Augeas API to update kernel parameters in GRUB's menu.lst
    # 
    #   * Required binaries: `grub`.
    # 
    # grub2
    # : Uses Augeas API to update kernel parameters in GRUB2's /etc/default/grub
    # 
    #   * Required binaries: `/sbin/grub2-mkconfig`.
    #   * Default for `osfamily` == `RedHat`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
