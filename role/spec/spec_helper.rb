require 'puppetlabs_spec_helper/module_spec_helper'
require 'beaker-rspec/beaker_shim'
require 'beaker-rspec/helpers/serverspec'
include BeakerRSpec::BeakerShim

require 'pry'

#FACTER_DIRECTORY='/etc/puppetlabs/facter/facts.d'
FACTER_DIRECTORY='/opt/puppetlabs/server/data/puppetserver/facts.d'

# UNSUPPORTED_PLATFORMS = ['Suse','windows','AIX','Solaris']

RSpec.configure do |c|
  #Try to guess what nodeset to load based on the test we are running
  #Rake's parallel execution uses Threads, so using enviroment variables 
  #is not an option (all Threads will try to change the value of the environment variable)
  product_line,file = c.files_to_run.first.split('/').last(2)
  role              = file.sub(/_spec.rb/,'')
  puts "Got #{product_line.upcase} #{role.upcase}"
  # Enable color
  c.tty = true

  # Define persistant hosts setting
  c.add_setting :hosts, :default => []
  # Define persistant options setting
  c.add_setting :options, :default => {}
  # Define persistant metadata object
  c.add_setting :metadata, :default => {}
  # Define persistant logger object
  c.add_setting :logger, :default => nil
  # Define persistant default node
  c.add_setting :default_node, :default => nil

  #default option values
  defaults = {
    :nodeset     => 'default',
  }
  #read env vars
  env_vars = {
    :nodeset     => ENV['BEAKER_set'] || ENV['RS_SET'],
    :nodesetfile => ENV['BEAKER_setfile'] || ENV['RS_SETFILE'],
    :provision   => ENV['BEAKER_provision'] || ENV['RS_PROVISION'],
    :keyfile     => ENV['BEAKER_keyfile'] || ENV['RS_KEYFILE'],
    :debug       => ENV['BEAKER_debug'] || ENV['RS_DEBUG'],
    :destroy     => ENV['BEAKER_destroy'] || ENV['RS_DESTROY'],
  }.delete_if {|key, value| value.nil?}
  #combine defaults and env_vars to determine overall options
  options = defaults.merge(env_vars)

  # process options to construct beaker command string
  nodesetfile = options[:nodesetfile] || File.join("role/spec/acceptance/nodesets/#{product_line}","#{role}.yaml")
  fresh_nodes = options[:provision] == 'no' ? '--no-provision' : nil
  keyfile     = options[:keyfile] ? ['--keyfile', options[:keyfile]] : nil
  debug       = options[:debug] ? ['--log-level', 'debug'] : nil

  # Configure all nodes in nodeset
  c.setup([fresh_nodes, '--hosts', nodesetfile, keyfile, debug].flatten.compact)
  c.provision
  c.validate
  c.configure



  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
#  c.before :suite do
#    hosts.each do |host|
#      #Get the role for this host
#      role = host.host_hash[:roles]-['default']
#      on host, "echo /dev/null > /var/log/messages"
#      on host, "ntpdate 10.20.1.5"
#      on host, "mkdir -p #{FACTER_DIRECTORY}"
#      on host, "echo role=#{role[0]} > #{FACTER_DIRECTORY}/role.txt"
#      on host, "echo aon_env=#{product_line}_aat > #{FACTER_DIRECTORY}/aon_env.txt"
#      on host, puppet('config','set','environment',"#{product_line}_aat",'--section agent')
#    end
#  end


  c.after :suite do
    case options[:destroy]
    when 'no'
      # Don't cleanup
    when 'onpass'
      c.cleanup if RSpec.world.filtered_examples.values.flatten.none?(&:exception)
    else
      c.cleanup
    end
  end
end

