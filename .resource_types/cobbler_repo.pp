# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Puppet type for cobbler repo object
Puppet::Resource::ResourceType3.new(
  'cobbler_repo',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The addresss of the yum mirror
    Puppet::Resource::Param(Any, 'mirror'),

    # Specifies what architecture the repository should use
    # 
    # Valid values are `i386`, `x86_64`, `ia64`, `ppc`, `ppc64`, `s390`, `arm`, `src`.
    Puppet::Resource::Param(Enum['i386', 'x86_64', 'ia64', 'ppc', 'ppc64', 's390', 'arm', 'src'], 'arch'),

    # Valid values are `rsync`, `rhn`, `wget`, `yum`, `apt`, `wget`.
    Puppet::Resource::Param(Enum['rsync', 'rhn', 'wget', 'yum', 'apt'], 'breed'),

    # List of package names part of a repo
    Puppet::Resource::Param(Any, 'rpmlist'),

    # Specifies that this yum repo is to be referenced directly via kickstarts or mirrored locally on the cobbler server
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'mirror_locally')
  ],
  [
    # A string identifying the repo
    Puppet::Resource::Param(Any, 'name', true),

    # Run reposync upon repo creation
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'reposync'),

    # The specific backend to use for this `cobbler_repo`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # : Provides cobbler repo via cobbler_api
    # 
    #   * Required binaries: `cobbler`.
    #   * Default for `osfamily` == `redhat`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
