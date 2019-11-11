require 'spec_helper'

describe 'any2bool' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

  it { is_expected.to run.with_params(true).and_return(true) }
  it { is_expected.to run.with_params(false).and_return(false) }

  it { is_expected.to run.with_params('1.5').and_return(true) }

  describe 'when testing stringy values that mean "true"' do
<<<<<<< HEAD
    %w[TRUE 1 t y true yes].each do |value|
=======
    ['TRUE', '1', 't', 'y', 'true', 'yes'].each do |value|
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end

  describe 'when testing stringy values that mean "false"' do
    ['FALSE', '', '0', 'f', 'n', 'false', 'no', 'undef', 'undefined', nil, :undef].each do |value|
      it { is_expected.to run.with_params(value).and_return(false) }
    end
  end

  describe 'when testing numeric values that mean "true"' do
    [1, '1', 1.5, '1.5'].each do |value|
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end

  describe 'when testing numeric that mean "false"' do
    [-1, '-1', -1.5, '-1.5', '0', 0].each do |value|
      it { is_expected.to run.with_params(value).and_return(false) }
    end
  end

  describe 'everything else returns true' do
    [[], {}, ['1'], [1], { :one => 1 }].each do |value|
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end
end
