# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manages kernel parameters stored in bootloaders.
Puppet::Resource::ResourceType3.new(
  'kernel_parameter',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Value of the parameter if applicable.  Many parameters are just keywords so this must be left blank, while others (e.g. 'vga') will take a value.
    Puppet::Resource::Param(Any, 'value')
  ],
  [
    # The parameter name, e.g. 'quiet' or 'vga'.
    Puppet::Resource::Param(Any, 'name', true),

    # The bootloader configuration file, if in a non-default location for the provider.
    Puppet::Resource::Param(Any, 'target'),

    # Boot mode(s) to apply the parameter to.  Either 'all' (default) to use the parameter on all boots (normal and recovery mode), 'default' for just the default boot entry, 'normal' for just normal boots or 'recovery' for just recovery boots.
    # 
    # Valid values are `all`, `default`, `normal`, `recovery`.
    Puppet::Resource::Param(Enum['all', 'default', 'normal', 'recovery'], 'bootmode'),

    # The specific backend to use for this `kernel_parameter`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # grub
    # : Uses Augeas API to update kernel parameters in GRUB's menu.lst
    # 
    #   * Default for `augeasprovider_grub_version` == `1`.
    # 
    # grub2
    # : Uses Augeas API to update kernel parameters in GRUB2's /etc/default/grub
    # 
    #   * Required binaries: `/sbin/grub2-mkconfig`.
    #   * Default for `operatingsystemmajrelease` == `7` and `osfamily` == `Redhat`. Default for `operatingsystem` == `Debian` and `operatingsystemmajrelease` == `8`. Default for `operatingsystem` == `Ubuntu` and `operatingsystemmajrelease` == `14.04`. Default for `augeasprovider_grub_version` == `2`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
