require 'spec_helper'

describe 'puppet_enterprise::amq::config::management_context', :type => :define do
  before(:each) do
    @title        = 'managementContext'
    @brokername   = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ managementContext: #{@title}"

    @params = {
      :brokername       => @brokername,
      :create_connector => true
    }

    @changes = "set #attribute/createConnector 'true'"

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:management_context) { "#{broker_context}/managementContext/managementContext" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    context 'additional_attributes' do
      before(:each) do
        @params.merge!({:additional_attributes => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/is not a Hash/) }
    end

    context 'context_ensure' do
      before(:each) do
        @params.merge!({:context_ensure => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/does not match/) }
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "destination_type=#{param}" do
        before(:each) do
          @params.merge!({ :context_ensure => param })
          @changes = "rm #{management_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end
  end

  context 'additional attributes' do
    before(:each) do
      @params.merge!({
        :additional_attributes => {
          'createMBeanServer' => 'true',
        }
      })
      @changes = [@changes]
      @changes << 'set #attribute/createMBeanServer true'
    end

    it { should contain_augeas_with_changes(@augeas_title, @changes) }
  end
end


