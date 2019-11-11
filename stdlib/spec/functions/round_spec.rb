require 'spec_helper'

<<<<<<< HEAD
describe 'round' do
=======
describe 'round', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params(34.3).and_return(34) }
  it { is_expected.to run.with_params(-34.3).and_return(-34) }
  it { is_expected.to run.with_params(34.5).and_return(35) }
  it { is_expected.to run.with_params(-34.5).and_return(-35) }
  it { is_expected.to run.with_params(34.7).and_return(35) }
  it { is_expected.to run.with_params(-34.7).and_return(-35) }
  it { is_expected.to run.with_params('test').and_raise_error Puppet::ParseError }
  it { is_expected.to run.with_params('test', 'best').and_raise_error Puppet::ParseError }
  it { is_expected.to run.with_params(3, 4).and_raise_error Puppet::ParseError }
end
