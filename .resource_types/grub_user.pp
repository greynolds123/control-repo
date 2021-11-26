# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manages GRUB2 Users - Does not apply to GRUB Legacy
# 
# Note: This type compares against the *active* GRUB configuration. The
# contents of the management file will not be updated unless the active
# configuration is out of sync with the expected configuration.
Puppet::Resource::ResourceType3.new(
  'grub_user',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # Purge all unmanaged users.
    # 
    # This does not affect any users that are not defined by Puppet! There is
    # no way to reliably eliminate the items from all other scripts without
    # potentially severely damaging the GRUB2 build scripts.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'purge'),

    # The user's password. If the password is not already in a GRUB2 compatible
    # form, it will be automatically converted.
    Puppet::Resource::Param(Any, 'password')
  ],
  [
    # The username of the GRUB2 user to be managed.
    Puppet::Resource::Param(Any, 'name', true),

    # If set, add this user to the 'superusers' list, if no superusers are set,
    # but grub_user resources have been declared, a compile error will be
    # raised.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'superuser'),

    # The file to which to write the user information.
    # 
    # Must be an absolute path.
    # 
    # Values can match `/^\/.+/`.
    Puppet::Resource::Param(Pattern[/^\/.+/], 'target'),

    # Report any unmanaged users as a warning during the Puppet run.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'report_unmanaged'),

    # The rounds to use when hashing the password.
    # 
    # Values can match `/^\d+$/`.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'rounds'),

    # The specific backend to use for this `grub_user`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # grub2
    # : Provides for the manipulation of GRUB2 User Entries
    # 
    #   * Required binaries: `/sbin/grub2-mkconfig`.
    #   * Default for `osfamily` == `RedHat`.
    #   * Supported features: `grub2`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
