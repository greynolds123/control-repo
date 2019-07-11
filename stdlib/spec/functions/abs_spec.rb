require 'spec_helper'
<<<<<<< HEAD

describe 'abs' do
  it { is_expected.not_to eq(nil) }

  describe 'signature validation in puppet3', :unless => RSpec.configuration.puppet_future do
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it {
      pending('Current implementation ignores parameters after the first.')
      is_expected.to run.with_params(1, 2).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
    }
  end

  describe 'signature validation in puppet4', :if => RSpec.configuration.puppet_future do
    it {
      pending 'the puppet 4 implementation'
      is_expected.to run.with_params.and_raise_error(ArgumentError)
    }
    it {
      pending 'the puppet 4 implementation'
      is_expected.to run.with_params(1, 2).and_raise_error(ArgumentError)
    }
    it {
      pending 'the puppet 4 implementation'
      is_expected.to run.with_params([]).and_raise_error(ArgumentError)
    }
    it {
      pending 'the puppet 4 implementation'
      is_expected.to run.with_params({}).and_raise_error(ArgumentError)
    }
    it {
      pending 'the puppet 4 implementation'
      is_expected.to run.with_params(true).and_raise_error(ArgumentError)
    }
  end

  it { is_expected.to run.with_params(-34).and_return(34) }
  it { is_expected.to run.with_params('-34').and_return(34) }
  it { is_expected.to run.with_params(34).and_return(34) }
  it { is_expected.to run.with_params('34').and_return(34) }
  it { is_expected.to run.with_params(-34.5).and_return(34.5) }
  it { is_expected.to run.with_params('-34.5').and_return(34.5) }
  it { is_expected.to run.with_params(34.5).and_return(34.5) }
  it { is_expected.to run.with_params('34.5').and_return(34.5) }
=======
if Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0
  describe 'abs' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params(-34).and_return(34) }
    it { is_expected.to run.with_params('-34').and_return(34) }
    it { is_expected.to run.with_params(34).and_return(34) }
    it { is_expected.to run.with_params('34').and_return(34) }
    it { is_expected.to run.with_params(-34.5).and_return(34.5) }
    it { is_expected.to run.with_params('-34.5').and_return(34.5) }
    it { is_expected.to run.with_params(34.5).and_return(34.5) }
    it { is_expected.to run.with_params('34.5').and_return(34.5) }
  end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
end
