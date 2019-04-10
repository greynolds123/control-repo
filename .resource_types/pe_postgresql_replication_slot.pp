# This file was automatically generated on 2019-03-02 14:49:17 -0800.
# Use the 'puppet generate types' command to regenerate this file.

# Manages Postgresql replication slots.
# 
# This type allows to create and destroy replication slots
# to register warm standby replication on a Postgresql
# master server.
Puppet::Resource::ResourceType3.new(
  'pe_postgresql_replication_slot',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # The name of the slot to create. Must be a valid replication slot name.
    # 
    # Values can match `/^[a-z0-9_]+$/`.
    Puppet::Resource::Param(Pattern[/^[a-z0-9_]+$/], 'name', true),

    # The specific backend to use for this `pe_postgresql_replication_slot`
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
