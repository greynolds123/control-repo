# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage a MongoDB user. This includes management of users password as well as privileges.
Puppet::Resource::ResourceType3.new(
  'mongodb_user',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The name of the user.
    Puppet::Resource::Param(Any, 'username'),

    # The user's target database.
    # 
    # Values can match `/^\w+$/`.
    Puppet::Resource::Param(Pattern[/^\w+$/], 'database'),

    # The user's roles.
    # 
    # Values can match `/^\w+$/`.
    Puppet::Resource::Param(Pattern[/^\w+$/], 'roles'),

    # The password hash of the user. Use mongodb_password() for creating hash.
    # 
    # Values can match `/^\w+$/`.
    Puppet::Resource::Param(Pattern[/^\w+$/], 'password_hash')
  ],
  [
    # The name of the resource.
    Puppet::Resource::Param(Any, 'name', true),

    # The maximum amount of two second tries to wait MongoDB startup.
    # 
    # Values can match `/^\d+$/`.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'tries'),

    # The specific backend to use for this `mongodb_user`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mongodb
    # : Manage users for a MongoDB database.
    # 
    #   * Default for `kernel` == `Linux`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
