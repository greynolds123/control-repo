require 'spec_helper'

describe 'validate_absolute_path' do
<<<<<<< HEAD
  after(:all) do
=======
  after(:each) do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end

  # Checking for deprecation warning
<<<<<<< HEAD
  it 'should display a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
=======
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    scope.expects(:warning).with(includes('This method is deprecated'))
    is_expected.to run.with_params('c:/')
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  end

  describe "valid paths handling" do
    %w{
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  end

  describe 'valid paths handling' do
    %w[
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      C:/
      C:\\
      C:\\WINDOWS\\System32
      C:/windows/system32
      X:/foo/bar
      X:\\foo\\bar
      \\\\host\\windows
      //host/windows
      /
      /var/tmp
      /var/opt/../lib/puppet
<<<<<<< HEAD
    }.each do |path|
=======
    ].each do |path|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      it { is_expected.to run.with_params(path) }
      it { is_expected.to run.with_params(['/tmp', path]) }
    end
  end

  describe 'invalid path handling' do
<<<<<<< HEAD
    context 'garbage inputs' do
      [
        nil,
        [ nil ],
        [ nil, nil ],
        { 'foo' => 'bar' },
        { },
        '',
      ].each do |path|
        it { is_expected.to run.with_params(path).and_raise_error(Puppet::ParseError, /is not an absolute path/) }
        it { is_expected.to run.with_params([path]).and_raise_error(Puppet::ParseError, /is not an absolute path/) }
        it { is_expected.to run.with_params(['/tmp', path]).and_raise_error(Puppet::ParseError, /is not an absolute path/) }
      end
    end

    context 'relative paths' do
      %w{
=======
    context 'with garbage inputs' do
      [
        nil,
        [nil],
        [nil, nil],
        { 'foo' => 'bar' },
        {},
        '',
      ].each do |path|
        it { is_expected.to run.with_params(path).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
        it { is_expected.to run.with_params([path]).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
        it { is_expected.to run.with_params(['/tmp', path]).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
      end
    end

    context 'with relative paths' do
      %w[
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        relative1
        .
        ..
        ./foo
        ../foo
        etc/puppetlabs/puppet
        opt/puppet/bin
        relative\\windows
<<<<<<< HEAD
      }.each do |path|
        it { is_expected.to run.with_params(path).and_raise_error(Puppet::ParseError, /is not an absolute path/) }
        it { is_expected.to run.with_params([path]).and_raise_error(Puppet::ParseError, /is not an absolute path/) }
        it { is_expected.to run.with_params(['/tmp', path]).and_raise_error(Puppet::ParseError, /is not an absolute path/) }
=======
      ].each do |path|
        it { is_expected.to run.with_params(path).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
        it { is_expected.to run.with_params([path]).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
        it { is_expected.to run.with_params(['/tmp', path]).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
<<<<<<< HEAD

=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
