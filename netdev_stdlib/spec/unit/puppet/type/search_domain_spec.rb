# encoding: utf-8

require 'spec_helper'
<<<<<<< HEAD

describe Puppet::Type.type(:search_domain) do
  it_behaves_like 'name is the namevar'
  it_behaves_like 'an ensurable type'
=======
describe 'search_domain' do
  describe 'old style' do
    fake_operatingsystem
    describe Puppet::Type.type(:search_domain) do
      it_behaves_like 'name is the namevar'
      it_behaves_like 'an ensurable type'
    end
  end
  describe 'resource-api' do
    describe 'the search_domain type' do
      it 'loads' do
        expect(Puppet::Type.type(:search_domain)).not_to be_nil
      end
    end
  end
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
end
