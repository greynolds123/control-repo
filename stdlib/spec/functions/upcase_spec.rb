require 'spec_helper'

<<<<<<< HEAD
describe 'upcase' do
=======
describe 'upcase', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('', '').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires an array, hash or object that responds to upcase}) }
    it { is_expected.to run.with_params([1]).and_raise_error(Puppet::ParseError, %r{Requires an array, hash or object that responds to upcase}) }
  end

  describe 'normal string handling' do
    it { is_expected.to run.with_params('abc').and_return('ABC') }
    it { is_expected.to run.with_params('Abc').and_return('ABC') }
    it { is_expected.to run.with_params('ABC').and_return('ABC') }
  end

  describe 'handling classes derived from String' do
    it { is_expected.to run.with_params(AlsoString.new('ABC')).and_return('ABC') }
  end

  describe 'strings in arrays handling' do
    it { is_expected.to run.with_params([]).and_return([]) }
<<<<<<< HEAD
    it { is_expected.to run.with_params(%w[One twO]).and_return(%w[ONE TWO]) }
=======
    it { is_expected.to run.with_params(['One', 'twO']).and_return(['ONE', 'TWO']) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end
end
