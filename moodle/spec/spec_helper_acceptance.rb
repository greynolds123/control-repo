require 'beaker-rspec'
require 'beaker_spec_helper'
require 'beaker/puppet_install_helper'
include BeakerSpecHelper

UNSUPPORTED_PLATFORMS = ['windows', 'Darwin']

# https://github.com/puppetlabs/beaker-puppet_install_helper
run_puppet_install_helper

RSpec.configure do |c|
  # Project root
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('-').last

  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      # copy current module to vm
      copy_module_to(host, :source => proj_root, :module_name => "moodle")

      # Ensure that the git package is installed (RedHat-specific package name)
      on host, puppet('apply -e "package { \'git\': ensure => installed }"')

      # https://github.com/camptocamp/beaker_spec_helper
      BeakerSpecHelper::spec_prep(host)
    end
  end
end
