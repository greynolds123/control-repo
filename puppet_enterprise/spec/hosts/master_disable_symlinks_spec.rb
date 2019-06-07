require 'spec_helper'

describe 'master_disable_symlinks', :type => :host do
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
    }
  end

  let(:facts) { @facter_facts }
  let(:pre_condition) {}

  it { should satisfy_all_relationships }

  it { should_not contain_file('/usr/local') }
  it { should_not contain_file('/usr/local/bin') }
  it { should_not contain_file('/usr/local/bin/facter') }
  it { should_not contain_file('/usr/local/bin/puppet') }
  it { should_not contain_file('/usr/local/bin/pe-man') }
  it { should_not contain_file('/usr/local/bin/hiera') }
  it { should_not contain_file('/usr/local/bin/mco') }
  it { should_not contain_file('/usr/local/bin/r10k') }
  it { should satisfy_all_relationships }
end
