define apt::conf (
  $content       = undef,
  $ensure        = present,
<<<<<<< HEAD
  $priority      = 50,
=======
  $priority      = '50',
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  $notify_update = undef,
) {

  unless $ensure == 'absent' {
    unless $content {
      fail('Need to pass in content parameter')
    }
  }

  apt::setting { "conf-${name}":
    ensure        => $ensure,
    priority      => $priority,
    content       => template('apt/_conf_header.erb', 'apt/conf.erb'),
    notify_update => $notify_update,
  }
}
