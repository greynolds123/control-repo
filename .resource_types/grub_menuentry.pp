# This file was automatically generated on 2019-06-08 13:59:53 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manages menu entries in the GRUB and GRUB2 systems.
# 
# NOTE: This may not cover all possible options and some options may apply to
#       either GRUB or GRUB2!
Puppet::Resource::ResourceType3.new(
  'grub_menuentry',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The filesystem root.
    # 
    # Values can match `/\(.*\)/`.
    Puppet::Resource::Param(Pattern[/\(.*\)/], 'root'),

    # If set, make this menu entry the default entry.
    # 
    # If more than one of these is defined across all :menuentry resources,
    # this is an error.
    # 
    # In GRUB2, there is no real guarantee that this will stick since entries
    # further down the line may have custom scripts which alter the default.
    # 
    # NOTE: You should not use this in conjunction with using the :grub_config
    #       type to set the system default.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'default_entry'),

    # The path to the kernel that you wish to boot.
    # 
    # Set this to ':default:' to copy the default kernel if one exists.
    # 
    # Set this to ':preserve:' to preserve the current entry. If a current
    # entry does not exist, the default will be copied. If there is no default,
    # this is an error.
    # 
    # Values can match `/^(\/.*|:(default|preserve):)/`.
    Puppet::Resource::Param(Pattern[/^(\/.*|:(default|preserve):)/], 'kernel'),

    # An array of kernel options to apply to the :kernel property.
    # 
    #  The following format is supported for the new options:
    #    ':defaults:'  => Copy defaults from the default GRUB entry
    #    ':preserve:'  => Preserve all existing options (if present)
    # 
    #    Note: ':defaults:' and ':preserve:' are mutually exclusive.
    # 
    #    All of the options below supersede any items affected by the above
    # 
    #    'entry(=.*)?'   => Ensure that `entry` exists *as entered*; replaces all
    #                       other options with the same name
    #    '!:entry(=.*)?' => Add this option to the end of the arguments
    #                       preserving any other options of the same name
    #    '-:entry'       => Ensure that all instances of `entry` do not exist
    #    '-:entry=foo'   => Ensure that only instances of `entry` with value `foo` do not exist
    # 
    # Note: Option removals and additions have higher precedence than preservation
    Puppet::Resource::Param(Any, 'kernel_options'),

    # An Array of module entry Arrays that apply to the given entry.
    # Since each Multiboot format boot image is unique, you must know what you
    # wish to pass to the module lines.
    # 
    # The one exception to this is that many of the linux multiboot settings
    # require the kernel and initrd to be passed to them. If you set the
    # ':defaults:' value anywhere in the options array, the default kernel
    # options will be copied to that location in the output.
    # 
    # The following format is supported for the new options:
    #   ':defaults:'  => Copy default options from the default *kernel* GRUB entry
    #   ':preserve:'  => Preserve all existing options (if present)
    # 
    #   Note: ':defaults:' and ':preserve:' are mutually exclusive.
    # 
    #   All of the options below supersede any items affected by the above
    # 
    #     'entry(=.*)?'   => Ensure that `entry` exists *as entered*; replaces all
    #                      other options with the same name
    #     '!:entry(=.*)?' => Add this option to the end of the arguments
    #                      preserving any other options of the same name
    #     '-:entry'       => Ensure that all instances of `entry` do not exist
    #     '-:entry=foo'   => Ensure that only instances of `entry` with value `foo` do not exist
    # 
    #   Note: Option removals and additions have higher precedence than preservation
    # 
    # Example:
    #   modules => [
    #     ['/vmlinuz.1.2.3.4','ro'],
    #     ['/initrd.1.2.3.4']
    #   ]
    Puppet::Resource::Param(Any, 'modules'),

    # The path to the initrd image.
    # 
    # Set this to ':default:' to copy the default kernel initrd if one exists.
    # 
    # Set this to ':preserve:' to preserve the current entry. If a current
    # entry does not exist, the default will be copied. If there is no default,
    # this is an error.
    # 
    # Values can match `/^(\/.*|:(default|preserve):)/`.
    Puppet::Resource::Param(Pattern[/^(\/.*|:(default|preserve):)/], 'initrd'),

    # In Legacy GRUB, having this set will add a 'makeactive' entry to the menuentry.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features grub.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'makeactive'),

    # Add this Array of classes to the menuentry.
    # 
    # 
    # 
    # Requires features grub2.
    Puppet::Resource::Param(Any, 'classes'),

    # In GRUB2, having this set will add a requirement for the listed users to
    # authenticate to the system in order to utilize the menu entry.
    # 
    # 
    # 
    # Requires features grub2.
    Puppet::Resource::Param(Any, 'users'),

    # If true, add the `load_video` command to the menuentry.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features grub2.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'load_video'),

    # An Array of plugins that should be included in this menuentry.
    # 
    # 
    # 
    # Requires features grub2.
    Puppet::Resource::Param(Any, 'plugins')
  ],
  [
    # The name of the menu entry.
    Puppet::Resource::Param(Any, 'name', true),

    # The bootloader configuration file, if in a non-default location for the
    # provider.
    # 
    # 
    # 
    # Requires features grub.
    Puppet::Resource::Param(Any, 'target'),

    # If set, ensure that linux16 and initrd16 are used for the kernel entries.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'load_16bit'),

    # If set, when using the ':preserve:' option in `kernel_options` or
    # `modules` will add the system defaults if the entry is being first
    # created. This is the same technique that grub2-mkconfig uses when
    # procesing entries.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'add_defaults_on_creation'),

    # The specific backend to use for this `grub_menuentry`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # grub
    # : Uses Augeas API to update GRUB menu entries
    # 
    #   * Required binaries: `grub`, `grubby`.
    #   * Supported features: `grub`.
    # 
    # grub2
    # : Provides for the manipulation of GRUB2 menuentries
    # 
    #   * Required binaries: `/sbin/grub2-mkconfig`, `grub2-set-default`, `grubby`.
    #   * Default for `osfamily` == `RedHat`.
    #   * Supported features: `grub2`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
