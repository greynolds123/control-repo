require 'spec_helper_acceptance'

describe 'moodle class' do
  context 'with required parameters only' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = %{
        $install_dir = '/opt/moodle'
        class { 'apache':
          mpm_module => 'prefork',
        }
        class { 'apache::mod::php': }
        class { 'mysql::server': }
        class { 'mysql::bindings': php_enable => true, }
        apache::vhost { $::fqdn:
          docroot        => $install_dir,
          manage_docroot => false,
          port           => '80',
        }
        class { 'moodle':
          install_dir => $install_dir,
          dbtype      => $dbtype,
          dbuser      => 'moodleuser',
          dbpass      => 'moodleP@ss',
          fullname    => 'Test Moodle Site',
          shortname   => 'Test',
          summary     => 'A moodle test site created via beaker',
          adminuser   => 'moodleadmin',
          adminpass   => 'adminP@ss',
          adminemail  => 'admin@host.com',
          require     => Class['mysql::server', 'apache::mod::php'],
        }
      }

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe port(80) do
      it { should be_listening }
    end

    describe file('/opt/moodle/config.php') do
      it { should exist }
    end

    describe command('curl `facter fqdn`') do
      its(:stdout) { should contain('<title>Test Moodle Site</title>') }
    end
  end
end
