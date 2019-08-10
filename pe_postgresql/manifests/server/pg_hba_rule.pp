# This resource manages an individual rule that applies to the file defined in
# $target. See README.md for more details.
define pe_postgresql::server::pg_hba_rule(
  $type,
  $database,
  $user,
  $auth_method,
  $address     = undef,
  $description = 'none',
  $auth_option = undef,
  $order       = '150',

  # Needed for testing primarily, support for multiple files is not really
  # working.
  $target      = $pe_postgresql::server::pg_hba_conf_path
) {

  if $pe_postgresql::server::manage_pg_hba_conf == false {
      fail('pe_postgresql::server::manage_pg_hba_conf has been disabled, so this resource is now unused and redundant, either enable that option or remove this resource from your manifests')
  } else {
    pe_validate_re($type, '^(local|host|hostssl|hostnossl)$',
    "The type you specified [${type}] must be one of: local, host, hostssl, hostnosssl")

    if($type =~ /^host/ and $address == undef) {
      fail('You must specify an address property when type is host based')
    }

    $allowed_auth_methods = $pe_postgresql::server::version ? {
      '9.3' => ['trust', 'reject', 'md5', 'sha1', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.2' => ['trust', 'reject', 'md5', 'sha1', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.1' => ['trust', 'reject', 'md5', 'sha1', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.0' => ['trust', 'reject', 'md5', 'sha1', 'password', 'gss', 'sspi', 'krb5', 'ident', 'ldap', 'radius', 'cert', 'pam'],
      '8.4' => ['trust', 'reject', 'md5', 'sha1', 'password', 'gss', 'sspi', 'krb5', 'ident', 'ldap', 'cert', 'pam'],
      '8.3' => ['trust', 'reject', 'md5', 'sha1', 'crypt', 'password', 'gss', 'sspi', 'krb5', 'ident', 'ldap', 'pam'],
      '8.2' => ['trust', 'reject', 'md5', 'crypt', 'password', 'krb5', 'ident', 'ldap', 'pam'],
      '8.1' => ['trust', 'reject', 'md5', 'crypt', 'password', 'krb5', 'ident', 'pam'],
      default => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam', 'crypt']
    }

    $auth_method_regex = pe_join(['^(', pe_join($allowed_auth_methods, '|'), ')$'],'')
    pe_validate_re($auth_method, $auth_method_regex,
    pe_join(["The auth_method you specified [${auth_method}] must be one of: ", pe_join($allowed_auth_methods, ', ')],''))

    # Create a rule fragment
    $fragname = "pg_hba_rule_${name}"
    pe_concat::fragment { $fragname:
      target  => $target,
      content => template('pe_postgresql/pg_hba_rule.conf'),
      order   => $order,
    }
  }
}
