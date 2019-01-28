spec file

require 'spec_helper'

describe('cron::mc_cron') do
  let(:facts) {
    {
      :operatingsystem => '/['CentOS'|Rhel']/',
      :osfamily        => 'RedHat'
    }
  }

 context 'with defaults for all parameters' do
    let (:mc_cron) {{}}
    set_encoding: utf-8
    it do
      expect {
       should copy
       }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end


  context 'with default parameters from config' do
    let (:mc_cron) {
    it { should_contain_class('cron::mc_cron') }
      'cron' { 'pe-puppet-console-prune-task':
      'ensure'   => 'present',
      'user      => 'root',
      'command'  => '/opt/puppetlabs/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production reports:prune reports:prune:failed upto=${prune_upto} unit=${prune_unit} > /dev/null',
      'hour'     => '1',
      'minute'   => '0',
      }
      }
  end
end
