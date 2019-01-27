require 'spec_helper'

<<<<<<< HEAD
describe 'empty' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  it {
    pending("Current implementation ignores parameters after the first.")
=======
describe 'empty', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it {
    pending('Current implementation ignores parameters after the first.')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError)
  }
  it { is_expected.to run.with_params(0).and_return(false) }
  it { is_expected.to run.with_params('').and_return(true) }
  it { is_expected.to run.with_params('one').and_return(false) }

  it { is_expected.to run.with_params(AlsoString.new('')).and_return(true) }
  it { is_expected.to run.with_params(AlsoString.new('one')).and_return(false) }

  it { is_expected.to run.with_params([]).and_return(true) }
  it { is_expected.to run.with_params(['one']).and_return(false) }

  it { is_expected.to run.with_params({}).and_return(true) }
<<<<<<< HEAD
  it { is_expected.to run.with_params({'key' => 'value'}).and_return(false) }
=======
  it { is_expected.to run.with_params('key' => 'value').and_return(false) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
