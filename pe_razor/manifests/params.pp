# Params file for pe_razor
#
# This class contains variables for use in the module that need to be conditionally determined, such as
# a path that is different across OS's
class pe_razor::params {
  include 'puppet_enterprise::params'

  $postgresql_default_database = $puppet_enterprise::params::postgresql_default_database
  $postgresql_client_package_name = $puppet_enterprise::params::postgresql_client_package_name
  $postgresql_server_package_name = $puppet_enterprise::params::postgresql_server_package_name
  $postgresql_contrib_package_name = $puppet_enterprise::params::postgresql_contrib_package_name

  # The current pe_razor module only supports RedHat/CentOS 6 & 7.
  $is_on_el = $::operatingsystem ? {
    'RedHat' => true,
    'CentOS' => true,
    default  => false
  }

  $is_valid_version = $::operatingsystemmajrelease ? {
    '6'       => true,
    '7'       => true,
    default   => false
  }

  # Determine the file extension. Pre-releases are .tar, releases are .tar.gz
  $file_extension = pe_build_version() ? {
    /^[^-]+-.+/ => 'tar',
    default     => 'tar.gz',
  }

  $pe_build = pe_compiling_server_version()

  # We would like to run silent with regards to the deprecation warning around
  # the package type's allow_virtual parameter. However, the allow_virtual
  # parameter did not exist prior to Puppet 3.6.1. Therefore we have a few
  # places where we need to set package resource defaults dependent on what
  # version of Puppet the client is running (so long as we support clients
  # older than 3.6.1). Performing the calculation here as it is used in more
  # than one location elsewhere in the module.
  $supports_allow_virtual = versioncmp($::puppetversion,'3.6.1') >= 0
  $allow_virtual_default = $supports_allow_virtual ? {
    true  => true,
    false => undef,
  }

  # This is for generating ssl certs; it is an arbitrary default.
  # Note that if this value is not specified, openssl sets generated
  # certs to be valid for 30 days by default.
  $openssl_days_valid = 3650

  $pe_razor_server_unified_layout_version = '1.0.1.0'
  # Determine razor paths based on version
  if $::pe_razor_server_version == undef or versioncmp($::pe_razor_server_version, $pe_razor_server_unified_layout_version) >= 0 {
    # AIO Paths

    # Core razor paths
    $fqdn = $facts['fqdn']
    $data_dir  = '/opt/puppetlabs/server/data/razor-server'
    $repo_dir  = '/opt/puppetlabs/server/data/razor-server/repo'
    $razor_etc = '/etc/puppetlabs/razor-server'
    $razor_ssl = "${razor_etc}/ssl"
    $config_defaults_path = '/opt/puppetlabs/server/apps/razor-server/config-defaults.yaml'
    $razor_client_cert = "${razor_ssl}/client-${fqdn}.cert.pem"
    $razor_client_csr = "${razor_ssl}/client-${fqdn}.csr"
    $razor_client_key = "${razor_ssl}/client-${fqdn}.key.pem"
    $razor_client_pk8_key = "${razor_ssl}/client-${fqdn}.key.pk8"

    $puppet_bin_dir  = '/opt/puppetlabs/puppet/bin'

    # Postgres paths
    $pg_version  = $puppet_enterprise::params::postgres_version
    $pgsqldir    = '/opt/puppetlabs/server/data/postgresql'
    $pg_bin_dir  = '/opt/puppetlabs/server/bin'
    $pg_sql_path = '/opt/puppetlabs/server/bin/psql'
    $pgsql_data_dir = "${pgsqldir}/${pg_version}/data"
    $pgsql_server_cert = "${pgsql_data_dir}/server-${fqdn}.crt"
    $pgsql_server_key  = "${pgsql_data_dir}/server-${fqdn}.key"

    # Java KS path
    $pe_java_ks_path = '/opt/puppetlabs/server/bin'

    # Torquebox Paths
    $torquebox_home       = '/opt/puppetlabs/server/apps/razor-server/share/torquebox'
    $razor_server         = '/opt/puppetlabs/server/apps/razor-server/share/razor-server'
    $razor_admin          = "${razor_server}/bin/razor-admin"
    $jboss_standalone_dir = '/opt/puppetlabs/server/apps/razor-server/share/torquebox/jboss/standalone'

    # Default config-defaults.yaml values
    $database_url = "jdbc:postgresql:razor?user=razor&sslmode=require&sslcert=${razor_client_cert}&sslkey=${razor_client_pk8_key}"
  }
  else {
    # Old Paths

    # Core razor paths
    $data_dir  = '/opt/puppet/razor'
    $repo_dir  = '/opt/puppet/var/razor/repo'
    $razor_etc = '/etc/puppetlabs/razor'
    $config_defaults_path = '/etc/puppetlabs/razor/config-defaults.yaml'
    $puppet_bin_dir  = '/opt/puppet/bin'

    # Postgres paths
    $pg_version  = '9.2'
    $pgsqldir    = '/opt/puppet/var/lib/pgsql'
    $pg_bin_dir  = '/opt/puppet/bin'
    $pg_sql_path = '/opt/puppet/bin/psql'

    # Java KS path
    $pe_java_ks_path = '/opt/puppet/bin'

    # Torquebox Paths
    $torquebox_home       = '/opt/puppet/share/torquebox'
    $razor_server         = '/opt/puppet/share/razor-server'
    $razor_admin          = '/opt/puppet/share/razor-server/bin/razor-admin'
    $jboss_standalone_dir = '/opt/puppet/share/torquebox/jboss/standalone'

    $upgrade_directory_ensure = directory
    $upgrade_script_ensure = file

    notify { "You are using an old version of pe-razor-server. Current: \
${$::pe_razor_server_version}. See the upgrade documentation at \
http://docs.puppetlabs.com/pe/latest/razor_upgrade.html":
      loglevel => warning
    }
  }
}
