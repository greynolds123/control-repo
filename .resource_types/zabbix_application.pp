# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage zabbix applications
# 
#   Example.
#     Zabbix_application {
#       zabbix_url => 'zabbix_server1',
#       zabbix_user => 'admin',
#       zabbix_pass => 'zabbix',
#     }
# 
#     zabbix_application{"app1":
#       ensure   => present,
#       template => 'template1',
#     }
# 
# It Raise exception on deleting an application which is a part of used template.
Puppet::Resource::ResourceType3.new(
  'zabbix_application',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # application name
    Puppet::Resource::Param(Any, 'name', true),

    # template to which the application is linked
    Puppet::Resource::Param(Any, 'template'),

    # The url on which the zabbix-api is available.
    Puppet::Resource::Param(Any, 'zabbix_url'),

    # Zabbix-api username.
    Puppet::Resource::Param(Any, 'zabbix_user'),

    # Zabbix-api password.
    Puppet::Resource::Param(Any, 'zabbix_pass'),

    # If apache is uses with ssl
    Puppet::Resource::Param(Any, 'apache_use_ssl'),

    # The specific backend to use for this `zabbix_application`
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
