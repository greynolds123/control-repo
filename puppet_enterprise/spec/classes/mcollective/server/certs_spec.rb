require 'spec_helper'

describe 'puppet_enterprise::mcollective::server::certs' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'RedHat',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'somenode.rspec',
      'clientcert'        => 'awesomecert',
    }
  end

  let(:facts) { @facter_facts }
  let(:unixcertdir) { '/etc/puppetlabs/mcollective/ssl' }
  let(:wincertdir) { '/ProgramData/PuppetLabs/mcollective/etc/ssl' }

  context "on an AIX machine" do
    before :each do
      @facter_facts['operatingsystem'] = 'AIX'
    end

    it { should compile }

    it { should contain_file(unixcertdir).with(
      'owner' => 'root',
      'group' => 'system',
      'mode'  => '0660',
    )}
  end

  context "on a RedHat machine" do
    it { should compile }

    it { should contain_file(unixcertdir).with(
      'owner' => 'root',
      'group' => 'root',
      'mode'  => '0660',
    )}
  end

  # XXX: If this spec comes before other platforms (redhat, aix),
  # the windows specs will fail if this class is run independently.
  # When rspec-puppet converts to_ral in the cycles_found? check:
  # https://github.com/rodjek/rspec-puppet/blob/v2.4.0/lib/rspec-puppet/matchers/compile.rb#L137
  # The windows provider on the generated Resource fails:
  # https://github.com/puppetlabs/puppet/blob/4.5.1/lib/puppet/provider/file/windows.rb#L84
  # Because supports_acl?() does not exist
  # because lib/puppet/util/windows/security has not been included because
  # Puppet.features.microsoft_windows? is false
  # Presumably running posix first ensures that posix provider is already
  # associated with the File Type?
  context "on a windows machine" do
    before :each do
      @facter_facts['osfamily'] = 'windows'
      @facter_facts['operatingsystem'] = 'windows'
      @facter_facts['common_appdata'] = '/ProgramData'
    end

    it { should compile }

    it { should contain_file(wincertdir).with(
      'owner' => 'S-1-5-32-544',
      'group' => 'S-1-5-32-544',
      'mode'  => '0660',
    )}
  end

  it { should satisfy_all_relationships }
end
