require 'spec_helper'

<<<<<<< HEAD
if ENV["FUTURE_PARSER"] == 'yes'
=======
if ENV['FUTURE_PARSER'] == 'yes'
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  describe 'type_of' do
    pending 'teach rspec-puppet to load future-only functions under 3.7.5' do
      it { is_expected.not_to eq(nil) }
    end
  end
end

if Puppet.version.to_f >= 4.0
  describe 'type_of' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(ArgumentError) }
=======
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    it { is_expected.to run.with_params('', '').and_raise_error(ArgumentError) }

    it 'gives the type of a string' do
      expect(subject.call({}, 'hello world')).to be_kind_of(Puppet::Pops::Types::PStringType)
    end

    it 'gives the type of an integer' do
      expect(subject.call({}, 5)).to be_kind_of(Puppet::Pops::Types::PIntegerType)
    end
  end
end
