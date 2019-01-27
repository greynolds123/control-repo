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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
