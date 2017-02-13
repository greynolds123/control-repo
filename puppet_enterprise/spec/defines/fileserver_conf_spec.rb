require 'spec_helper'

describe 'puppet_enterprise::fileserver_conf', :type => :define do
  let(:title) { 'testing testmount' }
  let(:params) do
    {
      :mountpoint => 'testmount',
      :path       => '/some/where',
    }
  end

  it do
    should contain_augeas('fileserver.conf testmount').with_changes([
      'set /files/etc/puppetlabs/puppet/fileserver.conf/testmount/path /some/where',
      'set /files/etc/puppetlabs/puppet/fileserver.conf/testmount/allow *',
    ])
  end
  it { should contain_augeas('fileserver.conf testmount').with_incl('/etc/puppetlabs/puppet/fileserver.conf') }
  it { should contain_augeas('fileserver.conf testmount').with_load_path('/opt/puppetlabs/puppet/share/augeas/lenses/dist') }
  it { should contain_augeas('fileserver.conf testmount').with_lens('PuppetFileserver.lns') }
end
