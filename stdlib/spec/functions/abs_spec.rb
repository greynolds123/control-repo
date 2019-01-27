require 'spec_helper'

describe 'abs' do
  it { is_expected.not_to eq(nil) }

  describe 'signature validation in puppet3', :unless => RSpec.configuration.puppet_future do
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it {
      pending("Current implementation ignores parameters after the first.")
      is_expected.to run.with_params(1, 2).and_raise_error(Puppet::ParseError, /wrong number of arguments/i)
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it {
      pending('Current implementation ignores parameters after the first.')
      is_expected.to run.with_params(1, 2).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    }
  end

  describe 'signature validation in puppet4', :if => RSpec.configuration.puppet_future do
<<<<<<< HEAD
    it { pending "the puppet 4 implementation"; is_expected.to run.with_params().and_raise_error(ArgumentError) }
    it { pending "the puppet 4 implementation"; is_expected.to run.with_params(1, 2).and_raise_error(ArgumentError) }
    it { pending "the puppet 4 implementation"; is_expected.to run.with_params([]).and_raise_error(ArgumentError) }
    it { pending "the puppet 4 implementation"; is_expected.to run.with_params({}).and_raise_error(ArgumentError) }
    it { pending "the puppet 4 implementation"; is_expected.to run.with_params(true).and_raise_error(ArgumentError) }
  end

  it { is_expected.to run.with_params(-34).and_return(34) }
  it { is_expected.to run.with_params("-34").and_return(34) }
  it { is_expected.to run.with_params(34).and_return(34) }
  it { is_expected.to run.with_params("34").and_return(34) }
  it { is_expected.to run.with_params(-34.5).and_return(34.5) }
  it { is_expected.to run.with_params("-34.5").and_return(34.5) }
  it { is_expected.to run.with_params(34.5).and_return(34.5) }
  it { is_expected.to run.with_params("34.5").and_return(34.5) }
=======
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
