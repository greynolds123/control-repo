<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'beaker-rspec'
require 'beaker/puppet_install_helper'

UNSUPPORTED_PLATFORMS = []

run_puppet_install_helper

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

=======
require 'puppet'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ %r{pe}i
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
<<<<<<< HEAD
    if ENV['FUTURE_PARSER'] == 'yes'
      default[:default_apply_opts] ||= {}
      default[:default_apply_opts].merge!({:parser => 'future'})
    end

    copy_root_module_to(default, :source => proj_root, :module_name => 'stdlib')
  end
end

def is_future_parser_enabled?
  if default[:type] == 'aio' || ENV['PUPPET_INSTALL_TYPE'] == 'agent'
    return true
  elsif default[:default_apply_opts]
    return default[:default_apply_opts][:parser] == 'future'
  end
  return false
end

def get_puppet_version
  (on default, puppet('--version')).output.chomp
end

RSpec.shared_context "with faked facts" do
  let(:facts_d) do
    puppet_version = get_puppet_version
    if fact('osfamily') =~ /windows/i
=======
  end
end

def return_puppet_version
  (on default, puppet('--version')).output.chomp
end

RSpec.shared_context 'with faked facts' do
  let(:facts_d) do
    puppet_version = return_puppet_version
    if fact('osfamily') =~ %r{windows}i
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      if fact('kernelmajversion').to_f < 6.0
        'C:/Documents and Settings/All Users/Application Data/PuppetLabs/facter/facts.d'
      else
        'C:/ProgramData/PuppetLabs/facter/facts.d'
      end
<<<<<<< HEAD
    elsif Puppet::Util::Package.versioncmp(puppet_version, '4.0.0') < 0 and fact('is_pe', '--puppet') == "true"
=======
    elsif Puppet::Util::Package.versioncmp(puppet_version, '4.0.0') < 0 && fact('is_pe', '--puppet') == 'true'
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      '/etc/puppetlabs/facter/facts.d'
    else
      '/etc/facter/facts.d'
    end
  end

  before :each do
<<<<<<< HEAD
    #No need to create on windows, PE creates by default
    if fact('osfamily') !~ /windows/i
=======
    # No need to create on windows, PE creates by default
    if fact('osfamily') !~ %r{windows}i
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      shell("mkdir -p '#{facts_d}'")
    end
  end

  after :each do
<<<<<<< HEAD
    shell("rm -f '#{facts_d}/fqdn.txt'", :acceptable_exit_codes => [0,1])
=======
    shell("rm -f '#{facts_d}/fqdn.txt'", :acceptable_exit_codes => [0, 1])
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end

  def fake_fact(name, value)
    shell("echo #{name}=#{value} > '#{facts_d}/#{name}.txt'")
  end
end
