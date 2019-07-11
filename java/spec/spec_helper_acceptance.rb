<<<<<<< HEAD
require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = [ "Darwin", "windows" ]

unless ENV["RS_PROVISION"] == "no" or ENV["BEAKER_provision"] == "no"
  hosts.each do |host|
    if host['platform'] =~ /sles-1/i ||  host['platform'] =~ /solaris-1/i
      get_stdlib = <<-stdlib
      package{'wget':}
      exec{'download':
        command => "wget -P /root/ https://forgeapi.puppetlabs.com/v3/files/puppetlabs-stdlib-4.3.2.tar.gz --no-check-certificate",
        path => ['/opt/csw/bin/','/usr/bin/']
      }
      stdlib
      apply_manifest_on(host, get_stdlib)
      # have to use force otherwise it checks ssl cert even though it is a local file
      on host, puppet('module install /root/puppetlabs-stdlib-4.3.2.tar.gz --force')
    else
      on host, puppet("module install puppetlabs-stdlib")
      # For test support
      on host, puppet("module install puppetlabs-apt")
    end
=======
require 'beaker-pe'
require 'beaker-puppet'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
configure_type_defaults_on(hosts)
install_module_on(hosts)
install_module_dependencies_on(hosts)

UNSUPPORTED_PLATFORMS = ['Darwin', 'windows'].freeze

unless ENV['RS_PROVISION'] == 'no' || ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    install_puppet_module_via_pmt_on(host, module_name: 'puppetlabs-apt')
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end
end

RSpec.configure do |c|
<<<<<<< HEAD
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    hosts.each do |host|
      copy_module_to(host, :source => proj_root, :module_name => "java")
    end
=======
  # Readable test descriptions
  c.formatter = :documentation
end

def idempotent_apply(hosts, manifest, opts = {}, &block)
  block_on hosts, opts do |host|
    file_path = host.tmpfile('apply_manifest.pp')
    create_remote_file(host, file_path, manifest + "\n")

    puppet_apply_opts = { :verbose => nil, 'detailed-exitcodes' => nil }
    on_options = { acceptable_exit_codes: [0, 2] }
    on host, puppet('apply', file_path, puppet_apply_opts), on_options, &block
    puppet_apply_opts2 = { :verbose => nil, 'detailed-exitcodes' => nil }
    on_options2 = { acceptable_exit_codes: [0] }
    on host, puppet('apply', file_path, puppet_apply_opts2), on_options2, &block
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end
end
