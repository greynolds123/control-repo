require 'spec_helper'

describe 'bool2str' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  [ 'true', 'false', nil, :undef, ''].each do |invalid|
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  ['true', 'false', nil, :undef, ''].each do |invalid|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    it { is_expected.to run.with_params(invalid).and_raise_error(Puppet::ParseError) }
  end
  it { is_expected.to run.with_params(true, 'yes', 'no', 'maybe').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(true, 'maybe').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(true, 0, 1).and_raise_error(Puppet::ParseError) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(true).and_return("true") }
  it { is_expected.to run.with_params(false).and_return("false") }
  it { is_expected.to run.with_params(true, 'yes', 'no').and_return("yes") }
  it { is_expected.to run.with_params(false, 'yes', 'no').and_return("no") }

=======
  it { is_expected.to run.with_params(true).and_return('true') }
  it { is_expected.to run.with_params(false).and_return('false') }
  it { is_expected.to run.with_params(true, 'yes', 'no').and_return('yes') }
  it { is_expected.to run.with_params(false, 'yes', 'no').and_return('no') }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
