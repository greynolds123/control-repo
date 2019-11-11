# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage a MongoDB Shard
Puppet::Resource::ResourceType3.new(
  'mongodb_shard',
  [
    # Valid values are `present`.
    Puppet::Resource::Param(Enum['present'], 'ensure'),

    # The shard member
    Puppet::Resource::Param(Any, 'member'),

    # The sharding keys
    Puppet::Resource::Param(Any, 'keys')
  ],
  [
    # The name of the shard
    Puppet::Resource::Param(Any, 'name'),

    # The specific backend to use for this `mongodb_shard`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mongo
    # : Manage mongodb sharding.
    # 
    #   * Required binaries: `mongo`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
