# This class is used to disable file sync on the master. It can also be used to set
# custom code_id and code_content commands for static catalogs in PE.
#
# @param code_id_command [String] The absolute path to a script to run to generate the code_id for an environment.
# @param code_content_command [String] The absolute path to a script to run to retrieve a file from an environment for a given code_id.
class puppet_enterprise::master::file_sync_disabled(
  Optional[String] $code_id_command       = undef,
  Optional[String] $code_content_command  = undef,
) inherits puppet_enterprise::params {

  $container = 'puppetserver'
  $confdir = "/etc/puppetlabs/${container}"

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => $container,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'versioned-code-service':
    namespace => 'puppetlabs.services.versioned-code-service.versioned-code-service',
  }

  Pe_hocon_setting {
    ensure => present,
    notify => Service["pe-${container}"],
  }

  #PE File Sync configuration
  file { "${confdir}/conf.d/file-sync.conf" :
    ensure => absent,
    notify => Service["pe-${container}"],
  }

  # we use pe_empty here and below because the empty string is truthy
  if (!pe_empty($code_id_command) and !pe_empty($code_content_command)) {
    # PE versioned code service configuration
    file { "${confdir}/conf.d/versioned-code.conf" :
      ensure => present,
    }
    pe_hocon_setting { 'versioned-code.code-id-command':
      path    => "${confdir}/conf.d/versioned-code.conf",
      setting => 'versioned-code.code-id-command',
      value   => $code_id_command,
    }
    pe_hocon_setting { 'versioned-code.code-content-command':
      path    => "${confdir}/conf.d/versioned-code.conf",
      setting => 'versioned-code.code-content-command',
      value   => $code_content_command,
    }
  } elsif (pe_empty($code_id_command) and pe_empty($code_content_command)) {
    # If these settings are empty or not present, we clean up the file
    # as these are the only settings used in versioned-code currently.
    file { "${confdir}/conf.d/versioned-code.conf" :
      ensure => absent,
    }
  } else {
    notify { 'missing-code-command-configuration':
      message =>  "Missing one of 'code_id_command', 'code_content_command' for 'puppet_enterprise::profile::master'.
    When enabling static catalogs without file-sync, both of these parameters must be set for pe-puppetserver to start." }
  }

  Pe_puppet_authorization::Rule {
    path   => "${confdir}/conf.d/auth.conf",
    notify => Service["pe-${container}"],
  }

  pe_puppet_authorization::rule { 'puppetlabs file sync api':
    ensure => absent,
  }

  pe_puppet_authorization::rule { 'puppetlabs file sync repo':
    ensure => absent,
  }
}
