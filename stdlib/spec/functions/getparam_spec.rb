require 'spec_helper'

describe 'getparam' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(ArgumentError, /Must specify a reference/) }
  it { is_expected.to run.with_params('User[one]').and_raise_error(ArgumentError, /Must specify name of a parameter/) }
  it { is_expected.to run.with_params('User[one]', 2).and_raise_error(ArgumentError, /Must specify name of a parameter/) }
  it { is_expected.to run.with_params('User[one]', []).and_raise_error(ArgumentError, /Must specify name of a parameter/) }
  it { is_expected.to run.with_params('User[one]', {}).and_raise_error(ArgumentError, /Must specify name of a parameter/) }
=======
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{Must specify a reference}) }
  it { is_expected.to run.with_params('User[one]').and_raise_error(ArgumentError, %r{Must specify name of a parameter}) }
  it { is_expected.to run.with_params('User[one]', 2).and_raise_error(ArgumentError, %r{Must specify name of a parameter}) }
  it { is_expected.to run.with_params('User[one]', []).and_raise_error(ArgumentError, %r{Must specify name of a parameter}) }
  it { is_expected.to run.with_params('User[one]', {}).and_raise_error(ArgumentError, %r{Must specify name of a parameter}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

  describe 'when compared against a user resource with no params' do
    let(:pre_condition) { 'user { "one": }' }

    it { is_expected.to run.with_params('User[one]', 'ensure').and_return('') }
    it { is_expected.to run.with_params('User[two]', 'ensure').and_return('') }
    it { is_expected.to run.with_params('User[one]', 'shell').and_return('') }
  end

  describe 'when compared against a user resource with params' do
    let(:pre_condition) { 'user { "one": ensure => present, shell => "/bin/sh", managehome => false, }' }

    it { is_expected.to run.with_params('User[one]', 'ensure').and_return('present') }
    it { is_expected.to run.with_params('User[two]', 'ensure').and_return('') }
    it { is_expected.to run.with_params('User[one]', 'shell').and_return('/bin/sh') }
    it { is_expected.to run.with_params('User[one]', 'managehome').and_return(false) }
  end
<<<<<<< HEAD
=======

  describe 'when compared against a user resource with UTF8 and double byte params' do
    let(:pre_condition) { 'user { ["三", "ƒốưř"]: ensure => present }' }

    it { is_expected.to run.with_params('User[三]', 'ensure').and_return('present') }
    it { is_expected.to run.with_params('User[ƒốưř]', 'ensure').and_return('present') }
  end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
