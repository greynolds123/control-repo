# PostgreSQL's authentication system doesn't /exactly/ have a client cert
# whitelisting system, but it can be configured to act as such. This wraps that
# configuration.
define puppet_enterprise::pg::cert_whitelist_entry(
  String $user,
  String $database,
  String $allowed_client_certname,
  String $pg_ident_conf_path,
  String $ip_mask_allow_all_users_ssl,
  String $ipv6_mask_allow_all_users_ssl,
) {
  $ident_map_key = "${database}-${user}-map"

  Pe_postgresql::Server::Pg_hba_rule {
    user        => $user,
    description => 'none',
    type        => 'hostssl',
    database    => $database,
    auth_method => 'cert',
  }

  $pg_hba_rule = "Allow certificate mapped connections to ${database} as ${user}"

  if !defined(Pe_postgresql::Server::Pg_hba_rule["${pg_hba_rule} (ipv4)"]) {
    pe_postgresql::server::pg_hba_rule { "${pg_hba_rule} (ipv4)":
      auth_option => "map=${ident_map_key} clientcert=1",
      address     => $ip_mask_allow_all_users_ssl,
      order       => '0',
      notify      => Class['pe_postgresql::server::service'],
    }
  }

  if !defined(Pe_postgresql::Server::Pg_hba_rule["${pg_hba_rule} (ipv6)"]) {
    pe_postgresql::server::pg_hba_rule { "${pg_hba_rule} (ipv6)":
      auth_option => "map=${ident_map_key} clientcert=1",
      address     => $ipv6_mask_allow_all_users_ssl,
      order       => '1',
      notify      => Class['pe_postgresql::server::service'],
    }
  }

  puppet_enterprise::pg::ident_entry { $title:
    pg_ident_conf_path => $pg_ident_conf_path,
    database           => $database,
    ident_map_key      => $ident_map_key,
    client_certname    => $allowed_client_certname,
    user               => $user,
    notify             => Class['pe_postgresql::server::service'],
  }
}
