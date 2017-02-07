type Puppet_enterprise::Puppetdb::Sync_peer = Struct[{
  host => String,
  port => Integer,
  sync_interval_minutes => Integer
}]
