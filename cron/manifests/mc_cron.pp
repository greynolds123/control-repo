 #Control  the frequency of how the database is pruned.
  class cron::mc_cron { 
  cron { 'pe-puppet-console-prune-task':
  ensure   => present,
  user     => 'root',
  command  =>'/opt/puppetlabs/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production reports:prune reports:prune:failed upto=${prune_upto} unit=${prune_unit} > /dev/null',
  hour     => '1',
<<<<<<< HEAD
  minute   => '0',
=======
  minute   => '0', 
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  }
  }
