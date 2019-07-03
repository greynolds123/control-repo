class pe_repo (
  $base_path = "https://pm.puppetlabs.com/puppet-agent",
  $repo_dir  = '/opt/puppetlabs/server/data/packages',
  $prefix    = '/packages',
  Optional[String] $compile_master_pool_address = undef,
  String $master                                = pe_compile_master() ? {
      true  => pe_pick($compile_master_pool_address, $::settings::certname),
      false => $::settings::certname,
  },
  Optional[String] $http_proxy_host     = undef,
  Optional[Integer] $http_proxy_port    = 3128,
  Optional[String] $http_proxy_user     = undef,
  Optional[String] $http_proxy_password = undef,
  Boolean $enable_bulk_pluginsync       = true,
) {

  # Set up curl_option to ultimately pass to pe_staging
  if ($http_proxy_host) {
    $proxy_settings = "-x ${http_proxy_host}:${http_proxy_port}"
    if ($http_proxy_user) {
      $proxy_user_settings = "-U ${http_proxy_user}:${http_proxy_password}"
    } else {
      $proxy_user_settings = ''
    }
    $curl_option = "${proxy_settings} ${proxy_user_settings}"
  } else {
    $curl_option = ''
  }

  # The Puppet Collections version, will need to be manually bumped every time
  # Hopefully a rare occurence.
  $pc_version = 'puppet6'

  $root_staging_dir = '/opt/puppetlabs/server/data/staging'

  File {
    ensure => file,
    mode   => '644',
    owner  => 'root',
    group  => 'root',
  }

  # We do not want to use the pe_build fact because it is out of date during
  # upgrades of compile masters.
  # We instead use the compiling master's build version.  If and when
  # we improve puppet enterprise to allow the MoM to spin up compile masters
  # of arbitrary versions, then this will need to be revisted.
  $default_pe_build = pe_build_version()


  # We provide this variable as part of the "public API" of this module; any
  # files added to this directory will be served over http, so it's a good
  # place to put custom install scripts.
  $public_dir = "${repo_dir}/public"

  # Due to the new file structure, pe_repo may be called before pe_puppetserver
  # is installed, or it may be installed on a non server platform.
  # To work around this, do an exec mkdir -p to create the repo_dir.
  # We don't want to managage it because we don't care about permissions
  # or want to prevent people from managing it. We just care about the
  # packages/public/ directory.
  exec { 'create repo_dir':
    command => "mkdir -p ${repo_dir}",
    creates => $repo_dir,
    path    => '/sbin/:/bin/',
  }

  exec { 'create staging_dir':
    command => "mkdir -p ${root_staging_dir}",
    creates => $root_staging_dir,
    path    => '/sbin/:/bin/',
  }

  #build file structure
  file { [$repo_dir, $public_dir]:
    ensure  => directory,
    require => Exec['create repo_dir', 'create staging_dir'],
  }

  # PE-10160 - Manage directory permissions
  File[$public_dir] { mode => '0755' }

  # Add a latest symlink
  file { "${public_dir}/current":
    ensure => 'link',
    target => "${public_dir}/${default_pe_build}",
  }

  # puppet labs gpg key
  file { "${public_dir}/GPG-KEY-puppetlabs":
    source => 'puppet:///modules/pe_repo/GPG-KEY-puppetlabs',
  }

  # puppet, inc gpg key
  file { "${public_dir}/GPG-KEY-puppet":
    source => 'puppet:///modules/pe_repo/GPG-KEY-puppet',
  }

  # empty index.html file to disable /packages directory listing
  file { "${public_dir}/index.html":
    ensure => present,
  }

  if $enable_bulk_pluginsync {
    include pe_repo::bulk_pluginsync
  }
}
