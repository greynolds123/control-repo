# This file was automatically generated on 2019-03-02 14:49:17 -0800.
# Use the 'puppet generate types' command to regenerate this file.

Puppet::Resource::ResourceType3.new(
  'pe_postgresql_psql',
  [
    # The SQL command to execute via psql.
    Puppet::Resource::Param(Any, 'command')
  ],
  [
    # An arbitrary tag for your own reference; the name of the message.
    Puppet::Resource::Param(Any, 'name', true),

    # An optional SQL command to execute prior to the main :command; this is generally intended to be used for idempotency, to check for the existence of an object in the database to determine whether or not the main SQL command needs to be executed at all.
    Puppet::Resource::Param(Any, 'unless'),

    # The name of the database to execute the SQL command against.
    Puppet::Resource::Param(Any, 'db'),

    # The port of the database server to execute the SQL command against.
    Puppet::Resource::Param(Any, 'port'),

    # The schema search path to use when executing the SQL command
    Puppet::Resource::Param(Any, 'search_path'),

    # The path to psql executable.
    Puppet::Resource::Param(Any, 'psql_path'),

    # The system user account under which the psql command should be executed.
    Puppet::Resource::Param(Any, 'psql_user'),

    # The system user group account under which the psql command should be executed.
    Puppet::Resource::Param(Any, 'psql_group'),

    # The working directory under which the psql command should be executed.
    Puppet::Resource::Param(Any, 'cwd'),

    # If 'true', then the SQL will only be executed via a notify/subscribe event.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'refreshonly'),

    # The specific backend to use for this `pe_postgresql_psql`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
