require 'spec_helper'

describe 'validate_absolute_path' do
  after(:each) do
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end

  # Checking for deprecation warning
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
<<<<<<< HEAD
    scope.expects(:warning).with(includes('This method is deprecated'))
=======
    expect(scope).to receive(:warning).with(include('This method is deprecated'))
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    is_expected.to run.with_params('c:/')
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  end

  describe 'valid paths handling' do
<<<<<<< HEAD
    %w[
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
    ].each do |path|
=======
    ['C:/', 'C:\\', 'C:\\WINDOWS\\System32', 'C:/windows/system32', 'X:/foo/bar', 'X:\\foo\\bar', '\\\\host\\windows', '//host/windows', '/', '/var/tmp', '/var/opt/../lib/puppet'].each do |path|
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      it { is_expected.to run.with_params(path) }
      it { is_expected.to run.with_params(['/tmp', path]) }
    end
  end

  describe 'invalid path handling' do
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
<<<<<<< HEAD
      %w[
        relative1
        .
        ..
        ./foo
        ../foo
        etc/puppetlabs/puppet
        opt/puppet/bin
        relative\\windows
      ].each do |path|
=======
      ['relative1', '.', '..', './foo', '../foo', 'etc/puppetlabs/puppet', 'relative\\windows'].each do |path|
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        it { is_expected.to run.with_params(path).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
        it { is_expected.to run.with_params([path]).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
        it { is_expected.to run.with_params(['/tmp', path]).and_raise_error(Puppet::ParseError, %r{is not an absolute path}) }
      end
    end
  end
end
