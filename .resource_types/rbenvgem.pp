# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# A Ruby Gem installed inside an rbenv-installed Ruby
Puppet::Resource::ResourceType3.new(
  'rbenvgem',
  [
    # Valid values are `present` (also called `installed`), `absent`, `latest`. Values can match `/./`.
    Puppet::Resource::Param(Variant[Enum['present', 'installed', 'absent', 'latest'], Pattern[/./]], 'ensure')
  ],
  [
    # Gem qualified name within an rbenv repository
    Puppet::Resource::Param(Any, 'name'),

    # The Gem name
    Puppet::Resource::Param(Any, 'gemname'),

    # The ruby interpreter version
    Puppet::Resource::Param(Any, 'ruby'),

    # The rbenv root
    Puppet::Resource::Param(Any, 'rbenv'),

    # The rbenv owner
    Puppet::Resource::Param(Any, 'user'),

    # The specific backend to use for this `rbenvgem`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # default
    # : Maintains gems inside an RBenv setup
    # 
    #   * Required binaries: `su`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
