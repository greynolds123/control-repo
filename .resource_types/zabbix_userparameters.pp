# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

Puppet::Resource::ResourceType3.new(
  'zabbix_userparameters',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # An unique name for this define.
    Puppet::Resource::Param(Any, 'name', true),

    # FQDN of the machine.
    Puppet::Resource::Param(Any, 'hostname'),

    # Template which should be loaded for this host.
    Puppet::Resource::Param(Any, 'template'),

    # The url on which the zabbix-api is available.
    Puppet::Resource::Param(Any, 'zabbix_url'),

    # Zabbix-api username.
    Puppet::Resource::Param(Any, 'zabbix_user'),

    # Zabbix-api password.
    Puppet::Resource::Param(Any, 'zabbix_pass'),

    # If apache is uses with ssl
    Puppet::Resource::Param(Any, 'apache_use_ssl'),

    # The specific backend to use for this `zabbix_userparameters`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
