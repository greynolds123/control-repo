# Manage pglogical node creation
define puppet_enterprise::pg::pglogical::node(
  String $database,
  String $node_name,
  String $host,
  String $user,
  String $ssl_cert_file,
  String $ssl_key_file,
  String $ssl_ca_file,
) {
  $dsn_hash = {
    'host'        => $host,
    'port'        => $pe_postgresql::params::port,
    'dbname'      => $database,
    'user'        => $user,
    'sslmode'     => 'verify-full',
    'sslcert'     => $ssl_cert_file,
    'sslkey'      => $ssl_key_file,
    'sslrootcert' => $ssl_ca_file,
  }

  $dsn = pe_hash2dsn($dsn_hash)

  puppet_enterprise::psql { "${title}/sql":
    command => "SELECT pglogical.create_node(
      node_name := '${node_name}',
      dsn := '${dsn}')",
    unless  => "SELECT * from pglogical.node WHERE node_name='${node_name}'",
  }
}
