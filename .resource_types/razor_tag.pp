# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Razor Tag
Puppet::Resource::ResourceType3.new(
  'razor_tag',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The tag rule (Array)
    Puppet::Resource::Param(Any, 'rule')
  ],
  [
    # The tag name
    Puppet::Resource::Param(Any, 'name', true),

    # The specific backend to use for this `razor_tag`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # rest
    # : REST provider for Razor tag
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
