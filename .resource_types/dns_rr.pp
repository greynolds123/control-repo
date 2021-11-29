# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# A Resource Record in the DNS
Puppet::Resource::ResourceType3.new(
  'dns_rr',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Time to live of the resource record
    Puppet::Resource::Param(Any, 'ttl'),

    # The resource record's data
    Puppet::Resource::Param(Any, 'rrdata')
  ],
  [
    # Class/Type/Name for the resource record
    Puppet::Resource::Param(Any, 'spec', true),

    # The zone to update
    Puppet::Resource::Param(Any, 'zone'),

    # The master server for the resource record
    Puppet::Resource::Param(Any, 'server'),

    # The DNS response section to check for existing record values
    # 
    # Valid values are `answer`, `authority`, `additional`.
    Puppet::Resource::Param(Enum['answer', 'authority', 'additional'], 'query_section'),

    # Keyname for the TSIG key used to update the record
    Puppet::Resource::Param(Any, 'keyname'),

    # The HMAC type of the update key
    Puppet::Resource::Param(Any, 'hmac'),

    # The secret of the update key
    Puppet::Resource::Param(Any, 'secret'),

    # The specific backend to use for this `dns_rr`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # nsupdate
    # : * Required binaries: `dig`, `nsupdate`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['spec']
  },
  true,
  false)
