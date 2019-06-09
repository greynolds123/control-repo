# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage a MySQL user's rights.
Puppet::Resource::ResourceType3.new(
  'mysql_grant',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Privileges for user
    Puppet::Resource::Param(Any, 'privileges'),

    # Table to apply privileges to.
    # 
    # Values can match `/.*\..*/`, `/@/`.
    Puppet::Resource::Param(Pattern[/.*\..*/, /@/], 'table'),

    # User to operate on.
    Puppet::Resource::Param(Any, 'user'),

    # Options to grant.
    Puppet::Resource::Param(Any, 'options')
  ],
  [
    # Name to describe the grant.
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `mysql_grant`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mysql
    # : Set grants for users in MySQL.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
