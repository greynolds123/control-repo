require 'spec_helper'

<<<<<<< HEAD
describe 'ceiling' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('foo').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError) }
=======
describe 'ceiling', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params('foo').and_raise_error(Puppet::ParseError, %r{Wrong argument type given}) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{Wrong argument type given}) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  it { is_expected.to run.with_params(34).and_return(34) }
  it { is_expected.to run.with_params(-34).and_return(-34) }
  it { is_expected.to run.with_params(33.1).and_return(34) }
  it { is_expected.to run.with_params(-33.1).and_return(-33) }
<<<<<<< HEAD
=======
  it { is_expected.to run.with_params('33.1').and_return(34) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
end
