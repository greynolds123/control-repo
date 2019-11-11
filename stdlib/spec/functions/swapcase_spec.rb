require 'spec_helper'

describe 'swapcase' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params('a', '').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  describe 'with strings as inputs' do
    it { is_expected.to run.with_params('').and_return('') }
    it { is_expected.to run.with_params('one').and_return('ONE') }
    it { is_expected.to run.with_params('ONE').and_return('one') }
    it { is_expected.to run.with_params('oNe').and_return('OnE') }
  end
  describe 'with arrays as inputs' do
    it { is_expected.to run.with_params([]).and_return([]) }
    describe 'only containing strings' do
      it { is_expected.to run.with_params(['']).and_return(['']) }
      it { is_expected.to run.with_params(['one']).and_return(['ONE']) }
      it { is_expected.to run.with_params(['ONE']).and_return(['one']) }
      it { is_expected.to run.with_params(['oNe']).and_return(['OnE']) }
<<<<<<< HEAD
      it { is_expected.to run.with_params(%w[one ONE]).and_return(%w[ONE one]) }
      it { is_expected.to run.with_params(%w[ONE OnE]).and_return(%w[one oNe]) }
      it { is_expected.to run.with_params(%w[oNe one]).and_return(%w[OnE ONE]) }
=======
      it { is_expected.to run.with_params(['one', 'ONE']).and_return(['ONE', 'one']) }
      it { is_expected.to run.with_params(['ONE', 'OnE']).and_return(['one', 'oNe']) }
      it { is_expected.to run.with_params(['oNe', 'one']).and_return(['OnE', 'ONE']) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
    describe 'containing mixed types' do
      it { is_expected.to run.with_params(['OnE', {}]).and_return(['oNe', {}]) }
      it { is_expected.to run.with_params(['OnE', 1]).and_return(['oNe', 1]) }
      it { is_expected.to run.with_params(['OnE', []]).and_return(['oNe', []]) }
      it { is_expected.to run.with_params(['OnE', ['two']]).and_return(['oNe', ['two']]) }
    end
  end
  it 'accepts objects which extend String' do
    is_expected.to run.with_params(AlsoString.new('OnE')).and_return('oNe')
  end
end
