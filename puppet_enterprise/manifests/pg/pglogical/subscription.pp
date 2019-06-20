define puppet_enterprise::pg::pglogical::subscription(
  String $subscription_name,
  String $database,
  String $host = '',
  String $user = '',
  String $ssl_cert_file = '',
  String $ssl_key_file = '',
  String $ssl_ca_file = '',
  Enum[present, absent] $ensure = present,
  Integer $keepalives_idle = $puppet_enterprise::pglogical_keepalives_idle,
  Optional[Integer] $keepalives_interval = $puppet_enterprise::pglogical_keepalives_interval,
  Integer $keepalives_count = $puppet_enterprise::pglogical_keepalives_count,
  Boolean $synchronize_structure = true,
) {
  # lint:ignore:case_without_default
  case $ensure {
    present: {
      $provider_dsn_hash = {
        'host'                => $host,
        'port'                => $pe_postgresql::params::port,
        'dbname'              => $database,
        'user'                => $user,
        'sslmode'             => 'verify-full',
        'sslcert'             => $ssl_cert_file,
        'sslkey'              => $ssl_key_file,
        'sslrootcert'         => $ssl_ca_file,
        'keepalives_idle'     => $keepalives_idle,
        'keepalives_interval' => $keepalives_interval,
        'keepalives_count'    => $keepalives_count,
      }

      $provider_dsn = pe_hash2dsn($provider_dsn_hash)

      puppet_enterprise::psql { "pglogical_subscription ${title} create-sql":
        db      => $database,
        command => "SELECT pglogical.create_subscription(
                      subscription_name := '${subscription_name}',
                      provider_dsn := '${provider_dsn}',
                      synchronize_structure := ${synchronize_structure})",
        unless  => "SELECT * from pglogical.subscription WHERE sub_name='${subscription_name}'",
      }
    }

    absent: {
      puppet_enterprise::psql { "pglogical_subscription ${title} drop-sql":
        db      => $database,
        command => "SELECT pglogical.drop_subscription('${subscription_name}', false)",
        # query that returns rows if the subscription doesn't exist
        unless  => "SELECT *
                    FROM (SELECT COUNT(*)
                          FROM pglogical.subscription
                          WHERE sub_name='${subscription_name}') c
                    WHERE c.count = 0",
      }
    }
  }
  # lint:endignore
}
