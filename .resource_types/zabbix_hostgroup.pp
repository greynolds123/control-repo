# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage zabbix hostgroups
Puppet::Resource::ResourceType3.new(
  'zabbix_hostgroup',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # hostgroup name
    Puppet::Resource::Param(Any, 'name', true),

    # The url on which the zabbix-api is available.
    Puppet::Resource::Param(Any, 'zabbix_url'),

    # Zabbix-api username.
    Puppet::Resource::Param(Any, 'zabbix_user'),

    # Zabbix-api password.
    Puppet::Resource::Param(Any, 'zabbix_pass'),

    # If apache is uses with ssl
    Puppet::Resource::Param(Any, 'apache_use_ssl'),

    # The specific backend to use for this `zabbix_hostgroup`
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
