# encoding: utf-8

require 'spec_helper'
<<<<<<< HEAD

describe Puppet::Type.type(:radius_global) do
  let(:catalog) { Puppet::Resource::Catalog.new }
  let(:type) { described_class.new(name: 'emanon', catalog: catalog) }
  subject { described_class.attrclass(attribute) }

  it_behaves_like 'name is the namevar'
  it_behaves_like 'enabled type'
  it_behaves_like 'it has a string property', :key
  it_behaves_like 'array of strings property', attribute: :source_interface
  it_behaves_like 'array of strings property', attribute: :vrf

  describe 'key_format' do
    let(:attribute) { :key_format }
    include_examples 'numeric parameter', min: 0, max: 7
  end

  describe 'timeout' do
    let(:attribute) { :timeout }
    include_examples 'numeric parameter', min: 0, max: 604_800
  end

  describe 'retransmit_count' do
    let(:attribute) { :retransmit_count }
    include_examples 'numeric parameter', min: 0, max: 2048
=======
describe 'radius_global' do
  describe 'old style' do
    fake_operatingsystem
    describe Puppet::Type.type(:radius_global) do
      let(:catalog) { Puppet::Resource::Catalog.new }
      let(:type) { described_class.new(name: 'emanon', catalog: catalog) }
      subject { described_class.attrclass(attribute) }

      it_behaves_like 'name is the namevar'
      it_behaves_like 'enabled type'
      it_behaves_like 'it has a string property', :key
      it_behaves_like 'array of strings property', attribute: :source_interface
      it_behaves_like 'array of strings property', attribute: :vrf

      describe 'key_format' do
        let(:attribute) { :key_format }
        include_examples 'numeric parameter', min: 0, max: 7
      end

      describe 'timeout' do
        let(:attribute) { :timeout }
        include_examples '#doc Documentation'
        include_examples 'accepts values without munging', %w[0 604800 unset]
        include_examples 'rejects values', %w[foo -1 bar]
      end

      describe 'retransmit_count' do
        let(:attribute) { :retransmit_count }
        include_examples 'accepts values without munging', %w[0 2048 unset]
        include_examples 'rejects values', %w[foo -1 bar]
      end
    end
  end
  describe 'resource-api' do
    describe 'the radius_global type' do
      it 'loads' do
        expect(Puppet::Type.type(:radius_global)).not_to be_nil
      end
    end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end
end
