<<<<<<< HEAD
# This file was automatically generated on 2017-02-13 04:04:54 -0800.
=======
# This file was automatically generated on 2017-02-13 04:11:50 -0800.
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
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
    /(.*)/ => ['name']
  },
  true,
  false)
