require 'spec_helper'

describe 'member' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params([], [], []).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params([], '').and_return(false) }
  it { is_expected.to run.with_params([], ['']).and_return(false) }
  it { is_expected.to run.with_params([''], '').and_return(true) }
  it { is_expected.to run.with_params([''], ['']).and_return(true) }
  it { is_expected.to run.with_params([], 'one').and_return(false) }
  it { is_expected.to run.with_params([], ['one']).and_return(false) }
  it { is_expected.to run.with_params(['one'], 'one').and_return(true) }
  it { is_expected.to run.with_params(['one'], ['one']).and_return(true) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%w[one two three four], %w[four two]).and_return(true) }
  it { is_expected.to run.with_params(%w[ọאּẹ ŧẅồ ţҺŗęē ƒơџŕ], %w[ƒơџŕ ŧẅồ]).and_return(true) }
  it { is_expected.to run.with_params(%w[one two three four], %w[four five]).and_return(false) }
  it { is_expected.to run.with_params(%w[ọאּẹ ŧẅồ ţҺŗęē ƒơџŕ], ['ƒơџŕ', 'ƒί√ə']).and_return(false) }
=======
  it { is_expected.to run.with_params(['one', 'two', 'three', 'four'], ['four', 'two']).and_return(true) }
  it { is_expected.to run.with_params([1, 2, 3, 4], [4, 2]).and_return(true) }
  it { is_expected.to run.with_params([1, 'a', 'b', 4], [4, 'b']).and_return(true) }
  it { is_expected.to run.with_params(['ọאּẹ', 'ŧẅồ', 'ţҺŗęē', 'ƒơџŕ'], ['ƒơџŕ', 'ŧẅồ']).and_return(true) }
  it { is_expected.to run.with_params(['one', 'two', 'three', 'four'], ['four', 'five']).and_return(false) }
  it { is_expected.to run.with_params(['ọאּẹ', 'ŧẅồ', 'ţҺŗęē', 'ƒơџŕ'], ['ƒơџŕ', 'ƒί√ə']).and_return(false) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
end
