require 'spec_helper'

describe 'any2bool' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

  it { is_expected.to run.with_params(true).and_return(true) }
  it { is_expected.to run.with_params(false).and_return(false) }

  it { is_expected.to run.with_params('1.5').and_return(true) }

  describe 'when testing stringy values that mean "true"' do
<<<<<<< HEAD
    [ 'TRUE','1', 't', 'y', 'true', 'yes'].each do |value|
=======
    %w[TRUE 1 t y true yes].each do |value|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end

  describe 'when testing stringy values that mean "false"' do
<<<<<<< HEAD
    [ 'FALSE','', '0', 'f', 'n', 'false', 'no', 'undef', 'undefined', nil, :undef ].each do |value|
=======
    ['FALSE', '', '0', 'f', 'n', 'false', 'no', 'undef', 'undefined', nil, :undef].each do |value|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      it { is_expected.to run.with_params(value).and_return(false) }
    end
  end

  describe 'when testing numeric values that mean "true"' do
<<<<<<< HEAD
    [ 1,'1',1.5, '1.5'].each do |value|
=======
    [1, '1', 1.5, '1.5'].each do |value|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end

  describe 'when testing numeric that mean "false"' do
<<<<<<< HEAD
    [ -1, '-1', -1.5, '-1.5', '0', 0 ].each do |value|
=======
    [-1, '-1', -1.5, '-1.5', '0', 0].each do |value|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      it { is_expected.to run.with_params(value).and_return(false) }
    end
  end

  describe 'everything else returns true' do
<<<<<<< HEAD
    [ [], {}, ['1'], [1], {:one => 1} ].each do |value|
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end

=======
    [[], {}, ['1'], [1], { :one => 1 }].each do |value|
      it { is_expected.to run.with_params(value).and_return(true) }
    end
  end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
