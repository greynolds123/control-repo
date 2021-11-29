# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Manage MySQL datadirs with mysql_install_db OR mysqld (5.7.6 and above).
Puppet::Resource::ResourceType3.new(
  'mysql_datadir',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # The datadir name
    Puppet::Resource::Param(Any, 'datadir', true),

    # The basedir name, default /usr.
    # 
    # Values can match `/^\//`.
    Puppet::Resource::Param(Pattern[/^\//], 'basedir'),

    # The user for the directory default mysql (name, not uid).
    Puppet::Resource::Param(Any, 'user'),

    # MySQL defaults-extra-file with absolute path (*.cnf).
    # 
    # Values can match `/^\/.*\.cnf$/`.
    Puppet::Resource::Param(Pattern[/^\/.*\.cnf$/], 'defaults_extra_file'),

    # Insecure initialization (needed for 5.7.6++).
    Puppet::Resource::Param(Any, 'insecure'),

    # The path to the mysqld error log file (used with the --log-error option)
    # 
    # Values can match `/^\//`.
    Puppet::Resource::Param(Pattern[/^\//], 'log_error'),

    # The specific backend to use for this `mysql_datadir`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # mysql
    # : manage data directories for mysql instances
    # 
    #   * Required binaries: `mysql_install_db`, `mysqld`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['datadir']
  },
  true,
  false)
