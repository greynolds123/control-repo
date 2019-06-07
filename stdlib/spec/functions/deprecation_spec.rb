require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'deprecation' do
    before(:each) do
      # this is to reset the strict variable to default
      Puppet.settings[:strict] = :warning
    end

    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }

    it 'displays a single warning' do
<<<<<<< HEAD
      Puppet.expects(:warning).with(includes('heelo'))
=======
      if Puppet::Util::Package.versioncmp(Puppet.version, '5.0.0') >= 0 && Puppet::Util::Package.versioncmp(Puppet.version, '5.5.7') < 0
        expect(Puppet).to receive(:deprecation_warning).with('heelo at :', 'key')
        expect(Puppet).to receive(:deprecation_warning).with("Modifying 'autosign' as a setting is deprecated.")
      else
        expect(Puppet).to receive(:warning).with(include('heelo')).once
      end
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      is_expected.to run.with_params('key', 'heelo')
    end

    it 'displays a single warning, despite multiple calls' do
<<<<<<< HEAD
      Puppet.expects(:warning).with(includes('heelo')).once
=======
      if Puppet::Util::Package.versioncmp(Puppet.version, '5.0.0') >= 0 && Puppet::Util::Package.versioncmp(Puppet.version, '5.5.7') < 0
        expect(Puppet).to receive(:deprecation_warning).with('heelo at :', 'key').twice
        expect(Puppet).to receive(:deprecation_warning).with("Modifying 'autosign' as a setting is deprecated.")
      else
        expect(Puppet).to receive(:warning).with(include('heelo')).once
      end
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      (0..1).each do |_i|
        is_expected.to run.with_params('key', 'heelo')
      end
    end

    it 'fails twice with message, with multiple calls. when strict= :error' do
      Puppet.settings[:strict] = :error
<<<<<<< HEAD
      Puppet.expects(:warning).with(includes('heelo')).never
=======
      expect(Puppet).to receive(:warning).with(include('heelo')).never
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      (0..1).each do |_i|
        is_expected.to run.with_params('key', 'heelo').and_raise_error(RuntimeError, %r{deprecation. key. heelo})
      end
    end

    it 'displays nothing, despite multiple calls. strict= :off' do
      Puppet.settings[:strict] = :off
<<<<<<< HEAD
      Puppet.expects(:warning).with(includes('heelo')).never
=======
      expect(Puppet).to receive(:warning).with(include('heelo')).never
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
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
<<<<<<< HEAD
      scope.expects(:warning).with(includes('heelo'))
=======
      expect(scope).to receive(:warning).with(include('heelo'))
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      is_expected.to run.with_params('key', 'heelo')
    end
  end
end
