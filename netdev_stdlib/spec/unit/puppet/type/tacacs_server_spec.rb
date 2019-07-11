# encoding: utf-8

require 'spec_helper'
<<<<<<< HEAD

describe Puppet::Type.type(:tacacs_server) do
  let(:catalog) { Puppet::Resource::Catalog.new }
  let(:type) { described_class.new(name: 'emanon', catalog: catalog) }
  subject { described_class.attrclass(attribute) }

  it_behaves_like 'name is the namevar'
  it_behaves_like 'it has a string property', :key
  it_behaves_like 'it has a string property', :hostname
  it_behaves_like 'an ensurable type'

  describe 'key_format' do
    let(:attribute) { :key_format }
    include_examples 'numeric parameter', min: 0, max: 7
  end

  describe 'port' do
    let(:attribute) { :port }
    include_examples 'numeric parameter', min: 0, max: 65_535
  end

  describe 'timeout' do
    let(:attribute) { :timeout }
    include_examples 'numeric parameter', min: 0, max: 604_800
  end

  it_behaves_like 'boolean', attribute: :single_connection
  it_behaves_like 'it has a string property', :group
=======
describe 'tacacs_server' do
  describe 'old style' do
    fake_operatingsystem
    describe Puppet::Type.type(:tacacs_server) do
      let(:catalog) { Puppet::Resource::Catalog.new }
      let(:type) { described_class.new(name: 'emanon', catalog: catalog) }
      subject { described_class.attrclass(attribute) }

      it_behaves_like 'name is the namevar'
      it_behaves_like 'it has a string property', :key
      it_behaves_like 'it has a string property', :hostname
      it_behaves_like 'an ensurable type'

      describe 'key_format' do
        let(:attribute) { :key_format }
        include_examples 'numeric parameter', min: 0, max: 7
      end

      describe 'port' do
        let(:attribute) { :port }
        include_examples 'numeric parameter', min: 0, max: 65_535
      end

      describe 'timeout' do
        let(:attribute) { :timeout }
        include_examples 'numeric parameter', min: 0, max: 604_800
      end

      it_behaves_like 'boolean', attribute: :single_connection
      it_behaves_like 'it has a string property', :group
    end
  end
  describe 'resource-api' do
    describe 'the tacacs_server type' do
      it 'loads' do
        expect(Puppet::Type.type(:tacacs_server)).not_to be_nil
      end
    end
  end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
end
