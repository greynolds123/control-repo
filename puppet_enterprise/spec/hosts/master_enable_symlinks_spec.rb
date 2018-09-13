require 'spec_helper'

describe 'master_enable_symlinks', :type => :host do
  before :each do
    @facter_facts = {
      'kernel'                    => 'Linux',
      'osfamily'                  => 'Debian',
      'operatingsystem'           => 'Debian',
      'lsbmajdistrelease'         => '6',
      'puppetversion'             => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'                     => 'true',
      'fqdn'                      => 'master.rspec',
      'clientcert'                => 'awesomecert',
      'pe_concat_basedir'         => '/tmp/file',
      'platform_symlink_writable' => true,
      'pcp_broker_host'   => 'pcp_broker.rspec',
      'pcp_broker_port'   => 4245,
    }

    Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
      nil
    end
  end

  let(:facts) { @facter_facts }
  let(:pre_condition) {}

  it { should satisfy_all_relationships }

  # Some systems will have the /usr/local and /usr/local/bin directories
  # pre-created as symlinks, so we should make sure Puppet doesn't clobber them
  it { should contain_file('/usr/local').with_replace(false) }
  it { should contain_file('/usr/local/bin').with_replace(false) }
  it { should contain_file('/usr/local/bin/facter') }
  it { should contain_file('/usr/local/bin/puppet') }
  it { should contain_file('/usr/local/bin/pe-man') }
  it { should contain_file('/usr/local/bin/hiera') }
  it { should contain_file('/usr/local/bin/mco') }
  it { should contain_file('/usr/local/bin/r10k') }
  it { should satisfy_all_relationships }
end
