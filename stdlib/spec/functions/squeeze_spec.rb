require 'spec_helper'

describe 'squeeze' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('', '', '').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('', '', '').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  it { is_expected.to run.with_params(1).and_raise_error(NoMethodError) }
  it { is_expected.to run.with_params({}).and_raise_error(NoMethodError) }
  it { is_expected.to run.with_params(true).and_raise_error(NoMethodError) }

  context 'when squeezing a single string' do
    it { is_expected.to run.with_params('').and_return('') }
    it { is_expected.to run.with_params('a').and_return('a') }
    it { is_expected.to run.with_params('aaaaaaaaa').and_return('a') }
    it { is_expected.to run.with_params('aaaaaaaaa', 'a').and_return('a') }
    it { is_expected.to run.with_params('aaaaaaaaabbbbbbbbbbcccccccccc', 'b-c').and_return('aaaaaaaaabc') }
  end

<<<<<<< HEAD
=======
  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params('ậậậậậậậậậậậậậậậậậậậậ').and_return('ậ') }
    it { is_expected.to run.with_params('語語語語語語語', '語').and_return('語') }
    it { is_expected.to run.with_params('ậậậậậậậậậậậậậậậậậ語語語語©©©©©', '©').and_return('ậậậậậậậậậậậậậậậậậ語語語語©') }
  end

>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  context 'when squeezing values in an array' do
    it {
      is_expected.to run \
        .with_params(['', 'a', 'aaaaaaaaa', 'aaaaaaaaabbbbbbbbbbcccccccccc']) \
<<<<<<< HEAD
        .and_return( ['', 'a', 'a',         'abc'])
=======
        .and_return(['', 'a', 'a', 'abc'])
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    }
    it {
      is_expected.to run \
        .with_params(['', 'a', 'aaaaaaaaa', 'aaaaaaaaabbbbbbbbbbcccccccccc'], 'a') \
<<<<<<< HEAD
        .and_return( ['', 'a', 'a',         'abbbbbbbbbbcccccccccc'])
=======
        .and_return(['', 'a', 'a', 'abbbbbbbbbbcccccccccc'])
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    }
    it {
      is_expected.to run \
        .with_params(['', 'a', 'aaaaaaaaa', 'aaaaaaaaabbbbbbbbbbcccccccccc'], 'b-c') \
<<<<<<< HEAD
        .and_return( ['', 'a', 'aaaaaaaaa', 'aaaaaaaaabc'])
=======
        .and_return(['', 'a', 'aaaaaaaaa', 'aaaaaaaaabc'])
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    }
  end

  context 'when using a class extending String' do
<<<<<<< HEAD
    it 'should call its squeeze method' do
=======
    it 'calls its squeeze method' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      value = AlsoString.new('aaaaaaaaa')
      value.expects(:squeeze).returns('foo')
      expect(subject).to run.with_params(value).and_return('foo')
    end
  end
end
