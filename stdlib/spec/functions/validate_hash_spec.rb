require 'spec_helper'

describe 'validate_hash' do
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

    describe 'check for deprecation warning' do
      after(:all) do
        ENV.delete('STDLIB_LOG_DEPRECATIONS')
      end
      # Checking for deprecation warning
      it 'should display a single deprecation' do
        ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
        scope.expects(:warning).with(includes('This method is deprecated'))
        is_expected.to run.with_params({'key' => 'value'})
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

    describe 'check for deprecation warning' do
      after(:each) do
        ENV.delete('STDLIB_LOG_DEPRECATIONS')
      end
      # Checking for deprecation warning
      it 'displays a single deprecation' do
        ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
        scope.expects(:warning).with(includes('This method is deprecated'))
        is_expected.to run.with_params('key' => 'value')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end

    describe 'valid inputs' do
      it { is_expected.to run.with_params({}) }
<<<<<<< HEAD
      it { is_expected.to run.with_params({'key' => 'value'}) }
      it { is_expected.to run.with_params({}, {'key' => 'value'}) }
      it { is_expected.to run.with_params({'key1' => 'value1'}, {'key2' => 'value2'}) }
    end

    describe 'invalid inputs' do
      it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, /is not a Hash/) }
      it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, /is not a Hash/) }
      it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, /is not a Hash/) }
      it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, /is not a Hash/) }
      it { is_expected.to run.with_params({}, []).and_raise_error(Puppet::ParseError, /is not a Hash/) }
      it { is_expected.to run.with_params({}, 1).and_raise_error(Puppet::ParseError, /is not a Hash/) }
      it { is_expected.to run.with_params({}, true).and_raise_error(Puppet::ParseError, /is not a Hash/) }
      it { is_expected.to run.with_params({}, 'one').and_raise_error(Puppet::ParseError, /is not a Hash/) }
=======
      it { is_expected.to run.with_params('key' => 'value') }
      it { is_expected.to run.with_params({}, 'key' => 'value') }
      it { is_expected.to run.with_params({ 'key1' => 'value1' }, 'key2' => 'value2') }
    end

    describe 'invalid inputs' do
      it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
      it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
      it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
      it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
      it { is_expected.to run.with_params({}, []).and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
      it { is_expected.to run.with_params({}, 1).and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
      it { is_expected.to run.with_params({}, true).and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
      it { is_expected.to run.with_params({}, 'one').and_raise_error(Puppet::ParseError, %r{is not a Hash}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end
