# This file was automatically generated on 2019-03-02 14:49:17 -0800.
# Use the 'puppet generate types' command to regenerate this file.

# Manages entries in a java keystore.  Uses composite namevars to
# accomplish the same alias spread across multiple target keystores.
Puppet::Resource::ResourceType3.new(
  'pe_java_ks',
  [
    # Has three states, the obvious present and absent plus latest.  Latest
    # will compare the on disk MD5 fingerprint of the certificate and to that
    # in keytool to determine if insync? returns true or false.  We redefine
    # insync? for this paramerter to accomplish this.
    # 
    # Valid values are `present`, `absent`, `latest`.
    Puppet::Resource::Param(Enum['present', 'absent', 'latest'], 'ensure')
  ],
  [
    # The alias that is used to identify the entry in the keystore.  We
    # are down casing it for you here because keytool will do so for you too.
    Puppet::Resource::Param(Any, 'name', true),

    # Destination file for the keystore.  We autorequire the parent
    # directory for convenience.
    Puppet::Resource::Param(Any, 'target', true),

    # An already signed certificate that we can place in the keystore.  We
    # autorequire the file for convenience.
    Puppet::Resource::Param(Any, 'certificate'),

    # If you desire for an application to be a server and encrypt traffic
    # you will need a private key.  Private key entries in a keystore must be
    # accompanied by a signed certificate for the keytool provider.
    Puppet::Resource::Param(Any, 'private_key'),

    # It has been found that some java applications do not properly send
    # intermediary certificate authorities, in this case you can bundle them
    # with the server certificate using this chain parameter.
    Puppet::Resource::Param(Any, 'chain'),

    # The password used to protect the keystore.  If private keys are
    # subsequently also protected this password will be used to attempt
    # unlocking...P.S. Let me know if you ever need a separate private key
    # password parameter...
    Puppet::Resource::Param(Any, 'password'),

    # The path to a file containing the password used to protect the
    # keystore. This cannot be used together with :password.
    Puppet::Resource::Param(Any, 'password_file'),

    # If the supplied password does not succeed in unlocking the
    # keystore file, then delete the keystore file and create a new one.
    # Default: false.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'password_fail_reset'),

    # When inputing certificate authorities into a keystore, they aren't
    # by default trusted so if you are adding a CA you need to set this to true.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'trustcacerts'),

    # The search path used for command (keytool, openssl) execution.
    # Paths can be specified as an array or as a ':' separated list.
    Puppet::Resource::Param(Any, 'path'),

    # Timeout for the keytool command in seconds.
    Puppet::Resource::Param(Any, 'keytool_timeout'),

    # The specific backend to use for this `pe_java_ks`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # keytool
    # : Uses a combination of openssl and keytool to manage Java keystores
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /^([^:]+)$/ => ['name'],
    /^(.*):(.*)$/ => ['name', 'target']
  },
  true,
  false)
