require 'spec_helper'

<<<<<<< HEAD
if Puppet.version.to_f >= 4.0
  describe 'deprecation' do
    before(:each) {
      # this is to reset the strict variable to default
      Puppet.settings[:strict] = :warning
    }

    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(ArgumentError) }

    it 'should display a single warning' do
=======
if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'deprecation' do
    before(:each) do
      # this is to reset the strict variable to default
      Puppet.settings[:strict] = :warning
    end

    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }

    it 'displays a single warning' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      Puppet.expects(:warning).with(includes('heelo'))
      is_expected.to run.with_params('key', 'heelo')
    end

<<<<<<< HEAD
    it 'should display a single warning, despite multiple calls' do
      Puppet.expects(:warning).with(includes('heelo')).once
      is_expected.to run.with_params('key', 'heelo')
      is_expected.to run.with_params('key', 'heelo')
    end

    it 'should fail twice with message, with multiple calls. when strict= :error' do
      Puppet.settings[:strict] = :error
      Puppet.expects(:warning).with(includes('heelo')).never
      is_expected.to run.with_params('key', 'heelo').and_raise_error(RuntimeError, /deprecation. key. heelo/)
      is_expected.to run.with_params('key', 'heelo').and_raise_error(RuntimeError, /deprecation. key. heelo/)
    end

    it 'should display nothing, despite multiple calls. strict= :off' do
      Puppet.settings[:strict] = :off
      Puppet.expects(:warning).with(includes('heelo')).never
      is_expected.to run.with_params('key', 'heelo')
      is_expected.to run.with_params('key', 'heelo')
    end

    after(:all) {
      # this is to reset the strict variable to default
      Puppet.settings[:strict] = :warning
    }
  end
else
  describe 'deprecation' do
    after(:all) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

    it 'should display a single warning' do
=======
    it 'displays a single warning, despite multiple calls' do
      Puppet.expects(:warning).with(includes('heelo')).once
      (0..1).each do |_i|
        is_expected.to run.with_params('key', 'heelo')
      end
    end

    it 'fails twice with message, with multiple calls. when strict= :error' do
      Puppet.settings[:strict] = :error
      Puppet.expects(:warning).with(includes('heelo')).never
      (0..1).each do |_i|
        is_expected.to run.with_params('key', 'heelo').and_raise_error(RuntimeError, %r{deprecation. key. heelo})
      end
    end

    it 'displays nothing, despite multiple calls. strict= :off' do
      Puppet.settings[:strict] = :off
      Puppet.expects(:warning).with(includes('heelo')).never
      (0..1).each do |_i|
        is_expected.to run.with_params('key', 'heelo')
      end
    end

    after(:each) do
      # this is to reset the strict variable to default
      Puppet.settings[:strict] = :warning
    end
  end
elsif Puppet.version.to_f < 4.0
  # Puppet version < 4 will use these tests.
  describe 'deprecation' do
    after(:each) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    before(:each) do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
    end
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

    it 'displays a single warning' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      scope.expects(:warning).with(includes('heelo'))
      is_expected.to run.with_params('key', 'heelo')
    end
  end
end
