require 'spec_helper'

describe 'is_hash' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params({}, {}).and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params({}, {}).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  it { is_expected.to run.with_params('').and_return(false) }
  it { is_expected.to run.with_params({}).and_return(true) }
  it { is_expected.to run.with_params([]).and_return(false) }
  it { is_expected.to run.with_params(1).and_return(false) }
end
