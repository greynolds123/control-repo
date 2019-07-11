require 'spec_helper'

describe 'reject' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params([], 'pattern', 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

  it {
    pending('reject does not actually check this, and raises NoMethodError instead')
    is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{first argument not an array})
  }
  it {
    pending('reject does not actually check this, and raises NoMethodError instead')
    is_expected.to run.with_params(1, 'two').and_raise_error(Puppet::ParseError, %r{first argument not an array})
  }
  it { is_expected.to run.with_params([], 'two').and_return([]) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%w[one two three], 'two').and_return(%w[one three]) }
  it { is_expected.to run.with_params(%w[one two three], 't(wo|hree)').and_return(['one']) }
  it { is_expected.to run.with_params(%w[όŉệ ţщồ ţңяέέ], 'ţ(щồ|ңяέέ)').and_return(['όŉệ']) }
=======
  it { is_expected.to run.with_params(['one', 'two', 'three'], 'two').and_return(['one', 'three']) }
  it { is_expected.to run.with_params(['one', 'two', 'three'], 't(wo|hree)').and_return(['one']) }
  it { is_expected.to run.with_params(['όŉệ', 'ţщồ', 'ţңяέέ'], 'ţ(щồ|ңяέέ)').and_return(['όŉệ']) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
end
