require 'spec_helper'

describe 'member' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it {
    pending("Current implementation ignores parameters after the first.")
    is_expected.to run.with_params([], [], []).and_raise_error(Puppet::ParseError, /wrong number of arguments/i)
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params([], [], []).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
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
  it { is_expected.to run.with_params(['one', 'two', 'three', 'four'], ['four', 'two']).and_return(true) }
  it { is_expected.to run.with_params(['one', 'two', 'three', 'four'], ['four', 'five']).and_return(false) }
=======
  it { is_expected.to run.with_params(%w[one two three four], %w[four two]).and_return(true) }
  it { is_expected.to run.with_params(%w[ọאּẹ ŧẅồ ţҺŗęē ƒơџŕ], %w[ƒơџŕ ŧẅồ]).and_return(true) }
  it { is_expected.to run.with_params(%w[one two three four], %w[four five]).and_return(false) }
  it { is_expected.to run.with_params(%w[ọאּẹ ŧẅồ ţҺŗęē ƒơџŕ], ['ƒơџŕ', 'ƒί√ə']).and_return(false) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
