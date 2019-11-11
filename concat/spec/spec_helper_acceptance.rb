<<<<<<< HEAD
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'acceptance/specinfra_stubs'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    if host['platform'] =~ /sles-1/i || host['platform'] =~ /solaris-1/i
      get_deps = <<-EOS
      package{'wget':}
      exec{'download-stdlib':
        command => "wget -P /root/ https://forgeapi.puppetlabs.com/v3/files/puppetlabs-stdlib-4.5.1.tar.gz --no-check-certificate",
        path    => ['/opt/csw/bin/','/usr/bin/']
      }
      EOS
      apply_manifest_on(host, get_deps)
      # have to use force otherwise it checks ssl cert even though it is a local file
      on host, puppet('module install /root/puppetlabs-stdlib-4.5.1.tar.gz --force --ignore-dependencies'), {:acceptable_exit_codes => [0, 1]}
    elsif host['platform'] =~ /windows/i
      on host, 'curl -k -o c:/puppetlabs-stdlib-4.5.1.tar.gz https://forgeapi.puppetlabs.com/v3/files/puppetlabs-stdlib-4.5.1.tar.gz'
      on host, puppet('module install c:/puppetlabs-stdlib-4.5.1.tar.gz --force --ignore-dependencies'), {:acceptable_exit_codes => [0, 1]}
    else
      on host, puppet('module install puppetlabs-stdlib'), {:acceptable_exit_codes => [0, 1]}
    end
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      copy_module_to(host, :source => proj_root, :module_name => 'concat')
    end
  end

  c.before(:all) do
    shell('mkdir -p /tmp/concat')
  end
  c.after(:all) do
    shell('rm -rf /tmp/concat /var/lib/puppet/concat')
  end

  c.treat_symbols_as_metadata_keys_with_true_values = true
end

=======
# frozen_string_literal: true

require 'serverspec'
require 'puppet_litmus'
require 'spec_helper_acceptance_local' if File.file?(File.join(File.dirname(__FILE__), 'spec_helper_acceptance_local.rb'))
include PuppetLitmus

if ENV['TARGET_HOST'].nil? || ENV['TARGET_HOST'] == 'localhost'
  puts 'Running tests against this machine !'
  if Gem.win_platform?
    set :backend, :cmd
  else
    set :backend, :exec
  end
else
  # load inventory
  inventory_hash = inventory_hash_from_inventory_file
  node_config = config_from_node(inventory_hash, ENV['TARGET_HOST'])

  if target_in_group(inventory_hash, ENV['TARGET_HOST'], 'docker_nodes')
    host = ENV['TARGET_HOST']
    set :backend, :docker
    set :docker_container, host
  elsif target_in_group(inventory_hash, ENV['TARGET_HOST'], 'ssh_nodes')
    set :backend, :ssh
    options = Net::SSH::Config.for(host)
    options[:user] = node_config.dig('ssh', 'user') unless node_config.dig('ssh', 'user').nil?
    options[:port] = node_config.dig('ssh', 'port') unless node_config.dig('ssh', 'port').nil?
    options[:keys] = node_config.dig('ssh', 'private-key') unless node_config.dig('ssh', 'private-key').nil?
    options[:password] = node_config.dig('ssh', 'password') unless node_config.dig('ssh', 'password').nil?
    options[:verify_host_key] = Net::SSH::Verifiers::Null.new unless node_config.dig('ssh', 'host-key-check').nil?
    host = if ENV['TARGET_HOST'].include?(':')
             ENV['TARGET_HOST'].split(':').first
           else
             ENV['TARGET_HOST']
           end
    set :host,        options[:host_name] || host
    set :ssh_options, options
    set :request_pty, true
  elsif target_in_group(inventory_hash, ENV['TARGET_HOST'], 'winrm_nodes')
    require 'winrm'

    set :backend, :winrm
    set :os, family: 'windows'
    user = node_config.dig('winrm', 'user') unless node_config.dig('winrm', 'user').nil?
    pass = node_config.dig('winrm', 'password') unless node_config.dig('winrm', 'password').nil?
    endpoint = "http://#{ENV['TARGET_HOST']}:5985/wsman"

    opts = {
      user: user,
      password: pass,
      endpoint: endpoint,
      operation_timeout: 300,
    }

    winrm = WinRM::Connection.new opts
    Specinfra.configuration.winrm = winrm
  end
end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
