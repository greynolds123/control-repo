require 'spec_helper'

describe 'is_ip_address' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params([], []).and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params([], []).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  it { is_expected.to run.with_params('1.2.3.4').and_return(true) }
  it { is_expected.to run.with_params('1.2.3.255').and_return(true) }
  it { is_expected.to run.with_params('1.2.3.256').and_return(false) }
  it { is_expected.to run.with_params('1.2.3').and_return(false) }
  it { is_expected.to run.with_params('1.2.3.4.5').and_return(false) }
  it { is_expected.to run.with_params('fe00::1').and_return(true) }
  it { is_expected.to run.with_params('fe80:0000:cd12:d123:e2f8:47ff:fe09:dd74').and_return(true) }
  it { is_expected.to run.with_params('FE80:0000:CD12:D123:E2F8:47FF:FE09:DD74').and_return(true) }
  it { is_expected.to run.with_params('fe80:0000:cd12:d123:e2f8:47ff:fe09:zzzz').and_return(false) }
  it { is_expected.to run.with_params('fe80:0000:cd12:d123:e2f8:47ff:fe09').and_return(false) }
  it { is_expected.to run.with_params('fe80:0000:cd12:d123:e2f8:47ff:fe09:dd74:dd74').and_return(false) }
  it { is_expected.to run.with_params('').and_return(false) }
  it { is_expected.to run.with_params('one').and_return(false) }
  it { is_expected.to run.with_params(1).and_return(false) }
  it { is_expected.to run.with_params({}).and_return(false) }
  it { is_expected.to run.with_params([]).and_return(false) }

<<<<<<< HEAD
  context 'Checking for deprecation warning', if: Puppet.version.to_f < 4.0 do
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'should display a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
      scope.expects(:warning).with(includes('This method is deprecated'))
      is_expected.to run.with_params('1.2.3.4').and_return(true)
    end
    it 'should display no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = "false"
      scope.expects(:warning).with(includes('This method is deprecated')).never
      is_expected.to run.with_params('1.2.3.4').and_return(true)
    end
    after(:all) do 
=======
  context 'Checking for deprecation warning', :if => Puppet.version.to_f < 4.0 do
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'displays a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
      scope.expects(:warning).with(includes('This method is deprecated'))
      is_expected.to run.with_params('1.2.3.4').and_return(true)
    end
    it 'displays no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'false'
      scope.expects(:warning).with(includes('This method is deprecated')).never
      is_expected.to run.with_params('1.2.3.4').and_return(true)
    end
    after(:each) do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
  end
end
