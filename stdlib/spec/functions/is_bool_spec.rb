require 'spec_helper'

describe 'is_bool' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(true, false).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(true).and_return(true) }
  it { is_expected.to run.with_params(false).and_return(true) }
  it { is_expected.to run.with_params([1]).and_return(false) }
  it { is_expected.to run.with_params([{}]).and_return(false) }
  it { is_expected.to run.with_params([[]]).and_return(false) }
  it { is_expected.to run.with_params([true]).and_return(false) }
  it { is_expected.to run.with_params('true').and_return(false) }
  it { is_expected.to run.with_params('false').and_return(false) }
  context 'with deprecation warning' do
    after(:each) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'displays a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
<<<<<<< HEAD
      scope.expects(:warning).with(includes('This method is deprecated'))
=======
      expect(scope).to receive(:warning).with(include('This method is deprecated'))
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      is_expected.to run.with_params(true).and_return(true)
    end
    it 'displays no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'false'
<<<<<<< HEAD
      scope.expects(:warning).with(includes('This method is deprecated')).never
=======
      expect(scope).to receive(:warning).with(include('This method is deprecated')).never
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      is_expected.to run.with_params(false).and_return(true)
    end
  end
end
