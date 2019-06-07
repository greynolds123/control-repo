 #Control  the frequency of how the database is pruned.
<<<<<<< HEAD
  class cron::mc_cron { 
  cron { 'pe-puppet-console-prune-task':
  ensure   => present,
  user     => 'root',
  command  =>'/opt/puppetlabs/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production reports:prune reports:prune:failed upto=${prune_upto} unit=${prune_unit} > /dev/null',
  hour     => '1',
  minute   => '0',
=======
  class cron::mc_cron {
  cron { 'pe-puppet-console-prune-task':
  ensure  => 'absent',
  user    => 'root',
  command =>'/opt/puppetlabs/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=$<%= environment %> reports:prune reports:prune:failed "upto=${prune_upto} unit=${prune_unit}" > /dev/null',
  hour    => '0',
  minute  => '15',
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  }
  }
