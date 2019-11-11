require 'spec_helper'

<<<<<<< HEAD
describe 'floor' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('foo').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError) }
=======
describe 'floor', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params('foo').and_raise_error(Puppet::ParseError, %r{Wrong argument type}) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{Wrong argument type}) }

>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  it { is_expected.to run.with_params(34).and_return(34) }
  it { is_expected.to run.with_params(-34).and_return(-34) }
  it { is_expected.to run.with_params(33.1).and_return(33) }
  it { is_expected.to run.with_params(-33.1).and_return(-34) }
end
