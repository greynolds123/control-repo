require 'spec_helper'

describe 'reverse' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params([], 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(['a']).and_return(['a']) }
  it { is_expected.to run.with_params(['one']).and_return(['one']) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%w[one two three]).and_return(%w[three two one]) }
  it { is_expected.to run.with_params(%w[one two three four]).and_return(%w[four three two one]) }
  it { is_expected.to run.with_params(%w[ổňë ťŵọ ŧңяəė ƒŏůŗ]).and_return(%w[ƒŏůŗ ŧңяəė ťŵọ ổňë]) }
=======
  it { is_expected.to run.with_params(['one', 'two', 'three']).and_return(['three', 'two', 'one']) }
  it { is_expected.to run.with_params(['one', 'two', 'three', 'four']).and_return(['four', 'three', 'two', 'one']) }
  it { is_expected.to run.with_params(['ổňë', 'ťŵọ', 'ŧңяəė', 'ƒŏůŗ']).and_return(['ƒŏůŗ', 'ŧңяəė', 'ťŵọ', 'ổňë']) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

  it { is_expected.to run.with_params('').and_return('') }
  it { is_expected.to run.with_params('a').and_return('a') }
  it { is_expected.to run.with_params('abc').and_return('cba') }
  it { is_expected.to run.with_params('abcd').and_return('dcba') }
  it { is_expected.to run.with_params('āβćđ').and_return('đćβā') }

  context 'when using a class extending String' do
    it 'calls its reverse method' do
      value = AlsoString.new('asdfghjkl')
<<<<<<< HEAD
      value.expects(:reverse).returns('foo')
=======
      expect_any_instance_of(AlsoString).to receive(:reverse).and_return('foo') # rubocop:disable RSpec/AnyInstance
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      expect(subject).to run.with_params(value).and_return('foo')
    end
  end
end
