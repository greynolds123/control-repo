require 'spec_helper'

<<<<<<< HEAD
describe 'min' do
=======
describe 'min', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(1).and_return(1) }
  it { is_expected.to run.with_params(1, 2).and_return(1) }
  it { is_expected.to run.with_params(1, 2, 3).and_return(1) }
  it { is_expected.to run.with_params(3, 2, 1).and_return(1) }
  it { is_expected.to run.with_params(12, 8).and_return(8) }
  it { is_expected.to run.with_params('one').and_return('one') }
  it { is_expected.to run.with_params('one', 'two').and_return('one') }
  it { is_expected.to run.with_params('one', 'two', 'three').and_return('one') }
  it { is_expected.to run.with_params('three', 'two', 'one').and_return('one') }
<<<<<<< HEAD
=======
  it { is_expected.to run.with_params('the', 'public', 'art', 'galleries').and_return('art') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

  describe 'implementation artifacts' do
    it { is_expected.to run.with_params(1, 'one').and_return(1) }
    it { is_expected.to run.with_params('1', 'one').and_return('1') }
    it { is_expected.to run.with_params('1.3e1', '1.4e0').and_return('1.3e1') }
    it { is_expected.to run.with_params(1.3e1, 1.4e0).and_return(1.4e0) }
  end
end
