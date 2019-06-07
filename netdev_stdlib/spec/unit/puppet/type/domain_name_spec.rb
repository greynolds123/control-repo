# encoding: utf-8

require 'spec_helper'
<<<<<<< HEAD

describe Puppet::Type.type(:domain_name) do
  it_behaves_like 'name is the namevar'
  it_behaves_like 'an ensurable type'
=======
describe 'domain_name' do
  describe 'old style' do
    fake_operatingsystem
    describe Puppet::Type.type(:domain_name) do
      it_behaves_like 'name is the namevar'
      it_behaves_like 'an ensurable type'
    end
  end
  describe 'resource-api' do
    describe 'the domain_name type' do
      it 'loads' do
        expect(Puppet::Type.type(:domain_name)).not_to be_nil
      end
    end
  end
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
end
