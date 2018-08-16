require 'spec_helper'

describe 'validate_bool' do
<<<<<<< HEAD
  after(:all) do
=======
  after(:each) do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end

  # Checking for deprecation warning
<<<<<<< HEAD
  it 'should display a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
=======
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    scope.expects(:warning).with(includes('This method is deprecated'))
    is_expected.to run.with_params(true)
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end

  describe 'acceptable values' do
    it { is_expected.to run.with_params(true) }
    it { is_expected.to run.with_params(false) }
    it { is_expected.to run.with_params(true, false, false, true) }
  end

  describe 'validation failures' do
<<<<<<< HEAD
    it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, /is not a boolean/) }
    it { is_expected.to run.with_params(true, 'one').and_raise_error(Puppet::ParseError, /is not a boolean/) }
    it { is_expected.to run.with_params('one', false).and_raise_error(Puppet::ParseError, /is not a boolean/) }
    it { is_expected.to run.with_params("true").and_raise_error(Puppet::ParseError, /is not a boolean/) }
    it { is_expected.to run.with_params("false").and_raise_error(Puppet::ParseError, /is not a boolean/) }
    it { is_expected.to run.with_params(true, "false").and_raise_error(Puppet::ParseError, /is not a boolean/) }
    it { is_expected.to run.with_params("true", false).and_raise_error(Puppet::ParseError, /is not a boolean/) }
    it { is_expected.to run.with_params("true", false, false, false, false, false).and_raise_error(Puppet::ParseError, /is not a boolean/) }
=======
    it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
    it { is_expected.to run.with_params(true, 'one').and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
    it { is_expected.to run.with_params('one', false).and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
    it { is_expected.to run.with_params('true').and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
    it { is_expected.to run.with_params('false').and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
    it { is_expected.to run.with_params(true, 'false').and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
    it { is_expected.to run.with_params('true', false).and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
    it { is_expected.to run.with_params('true', false, false, false, false, false).and_raise_error(Puppet::ParseError, %r{is not a boolean}) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end
