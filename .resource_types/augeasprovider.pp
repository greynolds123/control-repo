# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Dumb Augeas provider type
Puppet::Resource::ResourceType3.new(
  'augeasprovider',
  [

  ],
  [
    # The specific backend to use for this `augeasprovider`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # default
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
  },
  true,
  false)
