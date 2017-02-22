<<<<<<< HEAD
# This file was automatically generated on 2017-02-13 04:04:54 -0800.
=======
# This file was automatically generated on 2017-02-13 04:11:50 -0800.
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
# Use the 'puppet generate types' command to regenerate this file.

Puppet::Resource::ResourceType3.new(
  'pe_ini_subsetting',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The value of the subsetting to be defined.
    Puppet::Resource::Param(Any, 'value')
  ],
  [
    # An arbitrary name used as the identity of the resource.
    Puppet::Resource::Param(Any, 'name', true),

    # The name of the section in the ini file in which the setting should be defined.
    Puppet::Resource::Param(Any, 'section'),

    # The name of the setting to be defined.
    Puppet::Resource::Param(Any, 'setting'),

    # The name of the subsetting to be defined.
    Puppet::Resource::Param(Any, 'subsetting'),

    # The separator string between subsettings. Defaults to " "
    Puppet::Resource::Param(Any, 'subsetting_separator'),

    # The ini file Puppet will ensure contains the specified setting.
    Puppet::Resource::Param(Any, 'path'),

    # The separator string to use between each setting name and value. Defaults to " = ", but you could use this to override e.g. whether or not the separator should include whitespace.
    Puppet::Resource::Param(Any, 'key_val_separator'),

    # The character used to quote the entire value of the setting. Valid values are '', '"' and "'". Defaults to ''.
    Puppet::Resource::Param(Any, 'quote_char'),

    # The specific backend to use for this `pe_ini_subsetting`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(.*)/ => ['name']
  },
  true,
  false)
