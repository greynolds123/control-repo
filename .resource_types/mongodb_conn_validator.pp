# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Verify that a connection can be successfully established between a node
# and the mongodb server.  Its primary use is as a precondition to
# prevent configuration changes from being applied if the mongodb
# server cannot be reached, but it could potentially be used for other
# purposes such as monitoring.
Puppet::Resource::ResourceType3.new(
  'mongodb_conn_validator',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # An arbitrary name used as the identity of the resource. It can also be the connection string to test (ie. 127.0.0.1:27017)
    Puppet::Resource::Param(Any, 'name', true),

    # An array containing DNS names or IP addresses of the server where mongodb should be running.
    Puppet::Resource::Param(Any, 'server'),

    # The port that the mongodb server should be listening on.
    Puppet::Resource::Param(Any, 'port'),

    # The max number of seconds that the validator should wait before giving up and deciding that puppetdb is not running; defaults to 60 seconds.
    Puppet::Resource::Param(Any, 'timeout'),

    # The specific backend to use for this `mongodb_conn_validator`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # tcp_port
    # : A provider for the resource type `mongodb_conn_validator`,
    #   which validates the mongodb connection by attempting an https
    #   connection to the mongodb server.  Uses the puppet SSL certificate
    #   setup from the local puppet environment to authenticate.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
