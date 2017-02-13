require 'spec_helper'

describe 'puppet_enterprise::mcollective::client::user', :type => :define do
  context 'on a supported platform' do
    before :each do
      @facter_facts = {
        :osfamily              => 'RedHat',
        :lsbmajdistrelease     => '6',
        :puppetversion         => '3.6.2 (Puppet Enterprise 3.3.0)',
        :is_pe                 => 'true',
      }

      @params = {
        :user_name   => 'puppet-dashboard',
        :home_dir    => '/opt/puppet/share/puppet-dashboard',
      }
    end

    let(:title) { 'puppet-dashboard' }
    let(:facts) { @facter_facts }
    let(:params) { @params }

    context "creating the user" do
      it { should contain_user('puppet-dashboard').with('home' => '/opt/puppet/share/puppet-dashboard') }
      it { should contain_file('/opt/puppet/share/puppet-dashboard') }

      it { should contain_file('/opt/puppet/share/puppet-dashboard/.bashrc.custom').with(
        'ensure' => 'file',
        'owner'  => 'puppet-dashboard',
        'group'  => 'puppet-dashboard',
        'mode'   => '0600',
      )}

      it { should contain_pe_file_line("#{@params[:user_name]}:path").with(
        'path' => '/opt/puppet/share/puppet-dashboard/.bashrc.custom',
        'line' => 'export PATH="/opt/puppetlabs/puppet/bin:${PATH}"',
      )}
    end
  end
end
