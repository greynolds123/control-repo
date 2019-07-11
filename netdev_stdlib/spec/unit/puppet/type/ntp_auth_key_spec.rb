# encoding: utf-8

require 'spec_helper'
<<<<<<< HEAD

describe Puppet::Type.type(:ntp_auth_key) do
  let(:catalog) { Puppet::Resource::Catalog.new }
  let(:type) { described_class.new(name: 10, catalog: catalog) }
  subject { described_class.attrclass(attribute) }

  it_behaves_like 'numeric namevar', min: 1, max: 65_535
  it_behaves_like 'it has a string property', :password

  describe 'algorithm' do
    let(:attribute) { :algorithm }

    include_examples '#doc Documentation'
    include_examples 'algorithm property'
  end

  describe 'mode' do
    let(:attribute) { :mode }
    include_examples 'numeric parameter', min: 0, max: 7
=======
describe 'ntp_auth_key' do
  describe 'old style' do
    fake_operatingsystem
    describe Puppet::Type.type(:ntp_auth_key) do
      let(:catalog) { Puppet::Resource::Catalog.new }
      let(:type) { described_class.new(name: 10, catalog: catalog) }
      subject { described_class.attrclass(attribute) }

      it_behaves_like 'numeric namevar', min: 1, max: 65_535
      it_behaves_like 'it has a string property', :password

      describe 'algorithm' do
        let(:attribute) { :algorithm }

        include_examples '#doc Documentation'
        include_examples 'algorithm property'
      end

      describe 'mode' do
        let(:attribute) { :mode }
        include_examples 'numeric parameter', min: 0, max: 7
      end
    end
  end
  describe 'resource-api' do
    describe 'the ntp_auth_key type' do
      it 'loads' do
        expect(Puppet::Type.type(:ntp_auth_key)).not_to be_nil
      end
    end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end
end
