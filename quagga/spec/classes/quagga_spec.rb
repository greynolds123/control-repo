require 'spec_helper'
require 'shared_contexts'

describe 'quagga' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
      describe 'check default parameters' do
        let(:params) do
          {
            #:owner => "quagga",
            #:group => "quagga",
            #:mode => "0664",
            #:package => "quagga",
            #:enable => true,
            content: 'hostname test'
          }
        end
        # add these two lines in a single test block to enable puppet and hiera debug mode
        # Puppet::Util::Log.level = :debug
        # Puppet::Util::Log.newdestination(:console)
        it do
          is_expected.to compile.with_all_deps
        end

        it { is_expected.to contain_package('quagga') }
        it { is_expected.to contain_class('Quagga::Params') }
        it do
          is_expected.to contain_file('/etc/quagga/zebra.conf')
            .with(
              'content' => 'hostname test',
              'ensure'  => 'present',
              'group'   => 'quagga',
              'mode'    => '0664',
              'notify'  => 'Service[quagga]',
              'owner'   => 'quagga',
            )
        end
        it do
          is_expected.to contain_file('/usr/local/bin/quagga_status.sh')
            .with(
              'content' => /pgrep -u quagga/,
              'ensure'  => 'present',
              'mode'    => '0555'
            )
        end
        it do
          is_expected.to contain_file('/etc/profile.d/vtysh.sh')
            .with(
              'ensure' => 'present',
              'source' => 'puppet:///modules/quagga/vtysh.sh'
            )
        end
        it do
          is_expected.to contain_service('quagga')
            .with(
              'enable'    => 'true',
              'ensure'    => 'running',
              'hasstatus' => 'false',
              'start'     => '/etc/init.d/quagga restart',
              'status'    => '/usr/local/bin/quagga_status.sh'
            )
        end
        it do
          is_expected.to contain_ini_setting('zebra')
            .with(
              'setting' => 'zebra',
              'value'   => 'yes'
            )
        end
      end

      describe 'check changin default parameters' do
        context 'owner' do
          let(:params) {{ owner: 'foo' }}
          it { is_expected.to contain_file('/etc/quagga/zebra.conf').with_owner('foo') }
          it { is_expected.to contain_file('/usr/local/bin/quagga_status.sh').with_content(
          /pgrep -u foo/) }
        end
        context 'group' do
          let(:params) {{ group: 'foo' }}
          it { is_expected.to contain_file('/etc/quagga/zebra.conf').with_group('foo') }
        end
        context 'mode' do
          let(:params) {{ mode: '0600' }}
          it { is_expected.to contain_file('/etc/quagga/zebra.conf').with_mode('0600') }
        end
        context 'package' do
          let(:params) {{ package: 'foo' }}
          it { is_expected.to contain_package('foo') }
        end
        context 'enable' do
          let(:params) {{ enable: false }}
          it { is_expected.to contain_ini_setting('zebra').with(
            setting: 'zebra',
            value:   'no',
          ) }
        end
        context 'content' do
          let(:params) {{ content: 'foo' }}
          it { is_expected.to contain_file('/etc/quagga/zebra.conf').with_content(/foo/) }
        end
      end

      describe 'check bad parameters' do
        context 'owner' do
          let(:params) {{ owner: true }}
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'group' do
          let(:params) {{ group: [] }}
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'mode' do
          let(:params) {{ mode: 'foo' }}
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'package' do
          let(:params) {{ package: {} }}
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'enable' do
          let(:params) {{ enable: 'false' }}
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'content' do
          let(:params) {{ content: [] }}
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
