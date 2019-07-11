# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Razor Repository
Puppet::Resource::ResourceType3.new(
  'razor_repo',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The URL of the ISO to download
    Puppet::Resource::Param(Any, 'iso_url'),

    # The URL of a mirror (no downloads)
    Puppet::Resource::Param(Any, 'url'),

    # The default task to perform to install the OS
    Puppet::Resource::Param(Any, 'task')
  ],
  [
    # The repository name
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `razor_repo`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # rest
    # : REST provider for Razor repo
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
