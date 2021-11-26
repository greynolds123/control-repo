# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage a MongoDB replicaSet
Puppet::Resource::ResourceType3.new(
  'mongodb_replset',
  [
    # Valid values are `present`.
    Puppet::Resource::Param(Enum['present'], 'ensure'),

    # The replicaSet members
    Puppet::Resource::Param(Any, 'members')
  ],
  [
    # The name of the replicaSet
    Puppet::Resource::Param(Any, 'name'),

    # The replicaSet arbiter
    Puppet::Resource::Param(Any, 'arbiter'),

    # Host to use for Replicaset initialization
    Puppet::Resource::Param(Any, 'initialize_host'),

    # The specific backend to use for this `mongodb_replset`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mongo
    # : Manage hosts members for a replicaset.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
