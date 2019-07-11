require 'spec_helper'

<<<<<<< HEAD
describe 'sort' do
=======
describe 'sort', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params([], 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it {
      pending('stricter input checking')
      is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{requires string or array})
    }
    it {
      pending('stricter input checking')
      is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{requires string or array})
    }
    it {
      pending('stricter input checking')
      is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{requires string or array})
    }
  end

  context 'when called with an array' do
    it { is_expected.to run.with_params([]).and_return([]) }
    it { is_expected.to run.with_params(['a']).and_return(['a']) }
<<<<<<< HEAD
    it { is_expected.to run.with_params(%w[c b a]).and_return(%w[a b c]) }
=======
    it { is_expected.to run.with_params(['c', 'b', 'a']).and_return(['a', 'b', 'c']) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end

  context 'when called with a string' do
    it { is_expected.to run.with_params('').and_return('') }
    it { is_expected.to run.with_params('a').and_return('a') }
    it { is_expected.to run.with_params('cbda').and_return('abcd') }
  end
<<<<<<< HEAD
=======

  context 'when called with a number' do
    it { is_expected.to run.with_params('9478').and_return('4789') }
  end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
end
