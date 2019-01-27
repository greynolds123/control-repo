require 'spec_helper'

describe 'floor' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params("foo").and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('foo').and_raise_error(Puppet::ParseError) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(34).and_return(34) }
  it { is_expected.to run.with_params(-34).and_return(-34) }
  it { is_expected.to run.with_params(33.1).and_return(33) }
  it { is_expected.to run.with_params(-33.1).and_return(-34) }
end
