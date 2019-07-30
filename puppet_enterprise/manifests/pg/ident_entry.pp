define puppet_enterprise::pg::ident_entry (
  String $database,
  String $user,
  String $client_certname,
  String $ident_map_key,
  String $pg_ident_conf_path,
  ) {
  # Create an ident rule fragment for pg_ident.conf
  pe_concat::fragment { "${title} ident rule fragment":
    target  => $pg_ident_conf_path,
    content => "${ident_map_key} ${client_certname} ${user}",
  }
}
