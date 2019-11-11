require 'spec_helper'

describe 'empty', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError)
  }
<<<<<<< HEAD
=======
  it { is_expected.to run.with_params(false).and_raise_error(Puppet::ParseError, %r{Requires either array, hash, string or integer}) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  it { is_expected.to run.with_params(0).and_return(false) }
  it { is_expected.to run.with_params('').and_return(true) }
  it { is_expected.to run.with_params('one').and_return(false) }

  it { is_expected.to run.with_params(AlsoString.new('')).and_return(true) }
  it { is_expected.to run.with_params(AlsoString.new('one')).and_return(false) }

  it { is_expected.to run.with_params([]).and_return(true) }
  it { is_expected.to run.with_params(['one']).and_return(false) }

  it { is_expected.to run.with_params({}).and_return(true) }
  it { is_expected.to run.with_params('key' => 'value').and_return(false) }
end
