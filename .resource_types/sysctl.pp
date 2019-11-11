# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manages entries in /etc/sysctl.conf.
Puppet::Resource::ResourceType3.new(
  'sysctl',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # An alias for 'value'. Maintains interface compatibility with the traditional ParsedFile sysctl provider. If both are set, 'value' will take precedence over 'val'.
    Puppet::Resource::Param(Any, 'val'),

    # Value to change the setting to. Settings with multiple values (such as net.ipv4.tcp_mem) are represented as a single whitespace separated string.
    Puppet::Resource::Param(Any, 'value'),

    # Text to be stored in a comment immediately above the entry.  It will be automatically prepended with the name of the setting in order for the provider to know whether it controls the comment or not.
    Puppet::Resource::Param(Any, 'comment')
  ],
  [
    # The name of the setting, e.g. net.ipv4.ip_forward
    Puppet::Resource::Param(Any, 'name', true),

    # The file in which to store the settings, defaults to
    # `/etc/sysctl.conf`.
    Puppet::Resource::Param(Any, 'target'),

    # Whether to apply the value using the sysctl command.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'apply'),

    # If set, do not report an error if the system key does not exist. This is useful for systems that may need to load a kernel module prior to the sysctl values existing.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'silent'),

    # The specific backend to use for this `sysctl`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # augeas
    # : Uses Augeas API to update sysctl settings
    # 
    #   * Required binaries: `sysctl`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
