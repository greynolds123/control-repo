# encoding: utf-8

require 'spec_helper'
<<<<<<< HEAD

describe Puppet::Type.type(:network_snmp) do
  let(:catalog) { Puppet::Resource::Catalog.new }
  let(:type) { described_class.new(name: 'emanon', catalog: catalog) }

  subject { described_class.attrclass(attribute) }

  it_behaves_like 'name is the namevar'
  it_behaves_like 'enabled type'

  [:contact, :location].each do |param|
    describe param.to_s do
      let(:attribute) { param }
      include_examples '#doc Documentation'
      include_examples 'string value'
=======
describe 'network_snmp' do
  describe 'old style' do
    fake_operatingsystem
    describe Puppet::Type.type(:network_snmp) do
      let(:catalog) { Puppet::Resource::Catalog.new }
      let(:type) { described_class.new(name: 'emanon', catalog: catalog) }

      subject { described_class.attrclass(attribute) }

      it_behaves_like 'name is the namevar'
      it_behaves_like 'enabled type'

      %i[contact location].each do |param|
        describe param.to_s do
          let(:attribute) { param }
          include_examples '#doc Documentation'
          include_examples 'string value'
        end
      end
    end
  end
  describe 'resource-api' do
    describe 'the network_snmp type' do
      it 'loads' do
        expect(Puppet::Type.type(:network_snmp)).not_to be_nil
      end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    end
  end
end
