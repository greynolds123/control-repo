require 'spec_helper'

<<<<<<< HEAD
describe 'size' do
=======
describe 'size', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params([], 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Unknown type given}) }
  it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{Unknown type given}) }
  it { is_expected.to run.with_params('1').and_raise_error(Puppet::ParseError, %r{Requires either string, array or hash to work}) }
  it { is_expected.to run.with_params('1.0').and_raise_error(Puppet::ParseError, %r{Requires either string, array or hash to work}) }
  it { is_expected.to run.with_params([]).and_return(0) }
  it { is_expected.to run.with_params(['a']).and_return(1) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%w[one two three]).and_return(3) }
  it { is_expected.to run.with_params(%w[one two three four]).and_return(4) }
=======
  it { is_expected.to run.with_params(['one', 'two', 'three']).and_return(3) }
  it { is_expected.to run.with_params(['one', 'two', 'three', 'four']).and_return(4) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

  it { is_expected.to run.with_params({}).and_return(0) }
  it { is_expected.to run.with_params('1' => '2').and_return(1) }
  it { is_expected.to run.with_params('1' => '2', '4' => '4').and_return(2) }
  it { is_expected.to run.with_params('€' => '@', '竹' => 'ǿňè').and_return(2) }

  it { is_expected.to run.with_params('').and_return(0) }
  it { is_expected.to run.with_params('a').and_return(1) }
  it { is_expected.to run.with_params('abc').and_return(3) }
  it { is_expected.to run.with_params('abcd').and_return(4) }
  it { is_expected.to run.with_params('万').and_return(1) }
  it { is_expected.to run.with_params('āβćđ').and_return(4) }

<<<<<<< HEAD
  context 'when using a class extending String' do
    it 'calls its size method' do
      value = AlsoString.new('asdfghjkl')
      value.expects(:size).returns('foo')
=======
  context 'when using a class extending String', :unless => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.7') == 0 do
    it 'calls its size method' do
      value = AlsoString.new('asdfghjkl')
      expect(value).to receive(:size).and_return('foo')
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      expect(subject).to run.with_params(value).and_return('foo')
    end
  end
end
