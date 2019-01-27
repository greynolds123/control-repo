require 'spec_helper'

describe 'validate_string' do
<<<<<<< HEAD
  after(:all) do
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end
  
  # Checking for deprecation warning
  it 'should display a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
=======
  after(:each) do
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end

  # Checking for deprecation warning
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    scope.expects(:warning).with(includes('This method is deprecated'))
    is_expected.to run.with_params('', '')
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    describe 'valid inputs' do
      it { is_expected.to run.with_params('') }
      it { is_expected.to run.with_params(nil) }
      it { is_expected.to run.with_params('one') }
      it { is_expected.to run.with_params('one', 'two') }
    end

    describe 'invalid inputs' do
<<<<<<< HEAD
      it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, /is not a string/) }
      it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, /is not a string/) }
      it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, /is not a string/) }
      it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, /is not a string/) }
=======
      it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{is not a string}) }
      it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{is not a string}) }
      it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{is not a string}) }
      it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{is not a string}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end
