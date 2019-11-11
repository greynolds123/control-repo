define puppet_enterprise::deprecated_parameter() {
  $value = pe_getvar($title)
  if $value != undef {
    notify { "${title} is deprecated":
      message   => "The ${title} parameter is deprecated and will be removed in the next release; however it has been set to '${value}'. Please remove it from your Classifier classification, hiera data or /etc/puppetlabs/enterprise/conf.d/pe.conf as appropriate.",
      loglevel => 'warning',
    }
  }
}
