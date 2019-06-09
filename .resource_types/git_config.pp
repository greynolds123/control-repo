# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Used to configure git
# === Examples
# 
# 
#  git_config { 'user.name':
#    value => 'John Doe',
#  }
# 
#  git_config { 'user.email':
#    value => 'john.doe@example.com',
#  }
# 
#  git_config { 'user.name':
#    value   => 'Mike Color',
#    user    => 'vagrant',
#    require => Class['git'],
#  }
# 
#  git_config { 'http.sslCAInfo':
#    value   => $companyCAroot,
#    user    => 'root',
#    scope   => 'system',
#    require => Company::Certificate['companyCAroot'],
#  }
Puppet::Resource::ResourceType3.new(
  'git_config',
  [
    # The config value. Example Mike Color or john.doe@example.com
    Puppet::Resource::Param(Any, 'value')
  ],
  [
    # The name of the config
    Puppet::Resource::Param(Any, 'name', true),

    # The user for which the config will be set. Default value: root
    Puppet::Resource::Param(Any, 'user'),

    # The configuration key. Example: user.email.
    Puppet::Resource::Param(Any, 'key'),

    # Deprecated: the configuration section. For example, to set user.email, use section => "user", key => "email".
    Puppet::Resource::Param(Any, 'section'),

    # The scope of the configuration, can be system or global. Default value: global
    Puppet::Resource::Param(Any, 'scope'),

    # The specific backend to use for this `git_config`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # git_config
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
