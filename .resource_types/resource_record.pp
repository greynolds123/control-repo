# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# A Resource Record in the Domain Name System
Puppet::Resource::ResourceType3.new(
  'resource_record',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Time to live of the resource record
    Puppet::Resource::Param(Any, 'ttl'),

    # The resource record's data
    Puppet::Resource::Param(Any, 'data')
  ],
  [
    # A unique name for the puppet resource
    Puppet::Resource::Param(Any, 'title', true),

    # The record class
    # 
    # Valid values are `IN`, `CH`, `HS`.
    Puppet::Resource::Param(Enum['IN', 'CH', 'HS'], 'rrclass'),

    # The record type
    # 
    # Valid values are `A`, `AAAA`, `CNAME`, `NS`, `MX`, `SPF`, `SRV`, `NAPTR`, `PTR`, `TXT`, `DS`, `TLSA`, `SSHFP`.
    Puppet::Resource::Param(Enum['A', 'AAAA', 'CNAME', 'NS', 'MX', 'SPF', 'SRV', 'NAPTR', 'PTR', 'TXT', 'DS', 'TLSA', 'SSHFP'], 'type'),

    # The fully-qualified record name
    Puppet::Resource::Param(Any, 'record'),

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

    # Keyfile used to update the record
    Puppet::Resource::Param(Any, 'keyfile'),

    # The HMAC type of the update key
    Puppet::Resource::Param(Any, 'hmac'),

    # The secret of the update key
    Puppet::Resource::Param(Any, 'secret'),

    # The specific backend to use for this `resource_record`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # nsupdate
    # : * Required binaries: `dig`, `nsupdate`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['title']
  },
  true,
  false)
