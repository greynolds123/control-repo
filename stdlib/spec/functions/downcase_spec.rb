require 'spec_helper'

<<<<<<< HEAD
describe 'downcase' do
=======
describe 'downcase', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(100).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('abc').and_return('abc') }
  it { is_expected.to run.with_params('Abc').and_return('abc') }
  it { is_expected.to run.with_params('ABC').and_return('abc') }

  it { is_expected.to run.with_params(AlsoString.new('ABC')).and_return('abc') }
  it { is_expected.to run.with_params([]).and_return([]) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%w[ONE TWO]).and_return(%w[one two]) }
=======
  it { is_expected.to run.with_params(['ONE', 'TWO']).and_return(['one', 'two']) }
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  it { is_expected.to run.with_params(['One', 1, 'Two']).and_return(['one', 1, 'two']) }
end
