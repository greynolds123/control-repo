require 'spec_helper'

describe 'str2bool' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it {
    pending("Current implementation ignores parameters after the first.")
    is_expected.to run.with_params('true', 'extra').and_raise_error(Puppet::ParseError, /wrong number of arguments/i)
  }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, /Unknown type of boolean given/) }

  describe 'when testing values that mean "true"' do
    [ 'TRUE','1', 't', 'y', 'true', 'yes', true ].each do |value|
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params('true', 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{Unknown type of boolean given}) }

  describe 'when testing values that mean "true"' do
    ['TRUE', '1', 't', 'y', 'true', 'yes', true].each do |value|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end

  describe 'when testing values that mean "false"' do
<<<<<<< HEAD
    [ 'FALSE','', '0', 'f', 'n', 'false', 'no', false, 'undef', 'undefined' ].each do |value|
=======
    ['FALSE', '', '0', 'f', 'n', 'false', 'no', false, 'undef', 'undefined'].each do |value|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      it { is_expected.to run.with_params(value).and_return(false) }
    end
  end
end
