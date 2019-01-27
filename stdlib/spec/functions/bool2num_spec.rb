require 'spec_helper'

describe 'bool2num' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }

  [ true, 'true', AlsoString.new('true') ].each do |truthy|
    it { is_expected.to run.with_params(truthy).and_return(1) }
  end

  [ false, 'false', AlsoString.new('false') ].each do |falsey|
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }

  [true, 'true', AlsoString.new('true')].each do |truthy|
    it { is_expected.to run.with_params(truthy).and_return(1) }
  end

  [false, 'false', AlsoString.new('false')].each do |falsey|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    it { is_expected.to run.with_params(falsey).and_return(0) }
  end
end
