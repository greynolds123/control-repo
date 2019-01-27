require 'spec_helper'

describe 'ceiling' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params("foo").and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('foo').and_raise_error(Puppet::ParseError) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(34).and_return(34) }
  it { is_expected.to run.with_params(-34).and_return(-34) }
  it { is_expected.to run.with_params(33.1).and_return(34) }
  it { is_expected.to run.with_params(-33.1).and_return(-33) }
end
<<<<<<< HEAD

=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
