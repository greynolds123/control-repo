require 'spec_helper'

<<<<<<< HEAD
describe 'downcase' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(100).and_raise_error(Puppet::ParseError) }
=======
describe 'downcase', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params(100).and_raise_error(Puppet::ParseError, %r{Requires either array or string}) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  it { is_expected.to run.with_params('abc').and_return('abc') }
  it { is_expected.to run.with_params('Abc').and_return('abc') }
  it { is_expected.to run.with_params('ABC').and_return('abc') }

  it { is_expected.to run.with_params(AlsoString.new('ABC')).and_return('abc') }
  it { is_expected.to run.with_params([]).and_return([]) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%w[ONE TWO]).and_return(%w[one two]) }
=======
  it { is_expected.to run.with_params(['ONE', 'TWO']).and_return(['one', 'two']) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  it { is_expected.to run.with_params(['One', 1, 'Two']).and_return(['one', 1, 'two']) }
end
