 #Control  the frequency of how the database is pruned.
  class cron::mc_cron {
  cron { 'pe-puppet-console-prune-task':
  ensure  => 'absent',
  user    => 'root',
  command =>'/opt/puppetlabs/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=$<%= environment %> reports:prune reports:prune:failed "upto=${prune_upto} unit=${prune_unit}" > /dev/null',
  hour    => '0',
  minute  => '15',
  }
  }
