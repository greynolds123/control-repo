require 'spec_helper'

describe 'puppet_enterprise::amq::config::system_usage', :type => :define do
  before(:each) do
    @title = 'systemUsage'
    @brokername = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ systemUsage: #{@title}"

    @changes = [
      "set memoryUsage/memoryUsage/#attribute/limit '200mb'",
      "set storeUsage/storeUsage/#attribute/limit '1gb'",
      "set tempUsage/tempUsage/#attribute/limit '1gb'",
    ]

    @params = {
      :brokername => @brokername
    }

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:usage_context) { "#{broker_context}/systemUsage/systemUsage" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    %w[memory_usage store_usage temp_usage usage_ensure].each do |param|
      context "#{param}" do
        before(:each) do
          @params.merge!({ param => 'this tots should raise an error, yo' } )
          @changes = "rm #{usage_context}"
        end

        it { should compile.and_raise_error(/does not match/) }
      end
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "usage_ensure=#{param}" do
        before(:each) do
          @params.merge!({:usage_ensure => param})
          @changes = "rm #{usage_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end
  end
end
