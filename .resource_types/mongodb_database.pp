# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage MongoDB databases.
Puppet::Resource::ResourceType3.new(
  'mongodb_database',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # The name of the database.
    # 
    # Values can match `/^(\w|-)+$/`.
    Puppet::Resource::Param(Pattern[/^(\w|-)+$/], 'name', true),

    # The maximum amount of two second tries to wait MongoDB startup.
    # 
    # Values can match `/^\d+$/`.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'tries'),

    # The specific backend to use for this `mongodb_database`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mongodb
    # : Manages MongoDB database.
    # 
    #   * Default for `kernel` == `Linux`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
