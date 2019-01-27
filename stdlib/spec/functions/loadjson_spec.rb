require 'spec_helper'

describe 'loadjson' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(ArgumentError, /wrong number of arguments/i) }

  describe "when calling with valid arguments" do
    before :each do
      if RSpec.configuration.puppet_future
        allow(File).to receive(:read).with(/\/stdlib\/metadata.json/, {:encoding=>"utf-8"}).and_return('{"name": "puppetlabs-stdlib"}')
      else
        allow(File).to receive(:read).with(/\/stdlib\/metadata.json/).and_return('{"name": "puppetlabs-stdlib"}')
      end
    end

    context 'when a non-existing file is specified' do
      let(:filename) { '/tmp/doesnotexist' }
      before {
        allow(File).to receive(:exists?).with(filename).and_return(false).once
        allow(PSON).to receive(:load).never
      }
      it { is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'}) }
    end

    context 'when an existing file is specified' do
      let(:filename) { '/tmp/doesexist' }
      let(:data) { { 'key' => 'value' } }
      let(:json) { '{"key":"value"}' }
      before {
=======
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }

  describe 'when calling with valid arguments' do
    before :each do
      allow(File).to receive(:read).with(%r{\/(stdlib|test)\/metadata.json}, :encoding => 'utf-8').and_return('{"name": "puppetlabs-stdlib"}')
      allow(File).to receive(:read).with(%r{\/(stdlib|test)\/metadata.json}).and_return('{"name": "puppetlabs-stdlib"}')
    end

    context 'when a non-existing file is specified' do
      let(:filename) do
        if Puppet::Util::Platform.windows?
          'C:/tmp/doesnotexist'
        else
          '/tmp/doesnotexist'
        end
      end

      before(:each) do
        allow(File).to receive(:exists?).with(filename).and_return(false).once
        allow(PSON).to receive(:load).never
      end
      it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
      it { is_expected.to run.with_params(filename, 'đẽƒằưļŧ' => '٧ẵłựέ').and_return('đẽƒằưļŧ' => '٧ẵłựέ') }
      it { is_expected.to run.with_params(filename, 'デフォルト' => '値').and_return('デフォルト' => '値') }
    end

    context 'when an existing file is specified' do
      let(:filename) do
        if Puppet::Util::Platform.windows?
          'C:/tmp/doesexist'
        else
          '/tmp/doesexist'
        end
      end
      let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }
      let(:json) { '{"key":"value", {"ķęŷ":"νậŀųề" }, {"キー":"値" }' }

      before(:each) do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        allow(File).to receive(:exists?).with(filename).and_return(true).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        allow(PSON).to receive(:load).with(json).and_return(data).once
<<<<<<< HEAD
      }
=======
      end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      it { is_expected.to run.with_params(filename).and_return(data) }
    end

    context 'when the file could not be parsed' do
<<<<<<< HEAD
      let(:filename) { '/tmp/doesexist' }
      let(:json) { '{"key":"value"}' }
      before {
        allow(File).to receive(:exists?).with(filename).and_return(true).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        allow(PSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
      }
      it { is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'}) }
=======
      let(:filename) do
        if Puppet::Util::Platform.windows?
          'C:/tmp/doesexist'
        else
          '/tmp/doesexist'
        end
      end
      let(:json) { '{"key":"value"}' }

      before(:each) do
        allow(File).to receive(:exists?).with(filename).and_return(true).once
        allow(File).to receive(:read).with(filename).and_return(json).once
        allow(PSON).to receive(:load).with(json).once.and_raise StandardError, 'Something terrible have happened!'
      end
      it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end
