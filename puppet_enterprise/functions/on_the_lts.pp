function puppet_enterprise::on_the_lts() {
  $version = pe_compile_master() ? {
    true    => pe_compiling_server_version(),
    default => $::pe_build,
  }

  $on_the_lts = $version ? {
    /^2016.4./ => true,
    default    => false,
  }
}
