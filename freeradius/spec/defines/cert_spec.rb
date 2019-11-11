require 'spec_helper'
require 'shared_contexts'

describe 'freeradius::cert' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  let(:title) { 'XXreplace_meXX' }
  
  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:source => undef,
      #:content => undef,
      #:type => "key",
      #:ensure => present,
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_file('$::osfamily ? { RedHat => /etc/raddb, Debian => /etc/freeradius, default => /etc/raddb }/certs/XXreplace_meXX')
      .with(
        'content'   => 'undef',
        'ensure'    => 'present',
        'group'     => '$::osfamily ? { RedHat => radiusd, Debian => freerad, default => radiusd }',
        'mode'      => '$type ? { key => 0640, cert => 0644, default => 0644 }',
        'notify'    => 'Service[$fr_service]',
        'owner'     => 'root',
        'require'   => '[File[$fr_basepath/certs], Package[$fr_package], Group[$fr_group]]',
        'show_diff' => 'false',
        'source'    => 'undef'
      )
  end
end
