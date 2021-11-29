# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manages GPG keys.
Puppet::Resource::ResourceType3.new(
  'gpg_key',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # The file Puppet will ensure is imported.
    Puppet::Resource::Param(Any, 'path', true),

    # The specific backend to use for this `gpg_key`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # rpm
    # : * Required binaries: `gpg`, `rpm`.
    #   * Default for `osfamily` == `redhat`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['path']
  },
  true,
  false)
